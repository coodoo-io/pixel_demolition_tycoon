import 'dart:developer' as dev;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

double pixelSize = 28.0;

class PixelDemolitionTycoonGame extends FlameGame {
  int activePixelCount = 0;
  int tapStrength = 1;
  int level = 1;
  double money = 0;
  List<List<List<int>>> levels = [];
  final Map<double, double> shatterPositions = {}; // Map of X position to Y position
  AudioPool? laserBeamAudioPool;

  @override
  Future<void> onLoad() async {
    levels.add(await loadImageAndGetGreyScalePixels('assets/images/house.png'));
    final currentPixelModel = PixelModel(incrementMoney: incrementMoney, pixelList: levels[level - 1]);
    add(currentPixelModel);
    laserBeamAudioPool = await FlameAudio.createPool('laser_beam.mp3', minPlayers: 1, maxPlayers: 1);
  }

  Future<List<List<int>>> loadImageAndGetGreyScalePixels(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    List<int> bytes = data.buffer.asUint8List();
    final img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

    if (image == null) return <List<int>>[];

    final img.Image resizedImage = resizeImage(image);

    final width = resizedImage.width;
    final height = resizedImage.height;
    final List<List<int>> pixelList = [];

    for (var y = 0; y < height; y++) {
      final List<int> row = [];
      for (var x = 0; x < width; x++) {
        final img.Pixel pixel = resizedImage.getPixel(x, y);
        final num red = pixel.r;
        final num green = pixel.g;
        final num blue = pixel.b;
        final int greyScale = ((red + green + blue) / 3).round();
        row.add(greyScale);
      }
      pixelList.add(row);
    }

    dev.log('pixelList: $pixelList');
    return pixelList;
  }

  img.Image resizeImage(img.Image image) {
    int? newWidth;
    int? newHeight;
    const scale = 12;

    if (image.width > image.height) {
      newWidth = scale;
    } else {
      newHeight = scale;
    }

    return img.copyResize(image, width: newWidth, height: newHeight);
  }

  void incrementMoney() {
    money++;
    activePixelCount--;
    checkAllPixelsDestroyed();
  }

  void checkAllPixelsDestroyed() {
    if (activePixelCount == 0) {
      level++;
      money += 100;
      final nextLevel = levels.length >= level ? level : 1;
      final currentPixelModel = PixelModel(incrementMoney: incrementMoney, pixelList: levels[nextLevel - 1]);
      add(currentPixelModel);
    }
  }

  void upgradeTapStrength() {
    if (money >= 100) {
      money -= 100;
      tapStrength++;
    }
  }

  @override
  Color backgroundColor() => const Color(0xff2289be);
}

class PixelModel extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame> {
  PixelModel({required this.incrementMoney, required this.pixelList});

  final VoidCallback incrementMoney;
  final List<List<int>> pixelList;

  @override
  Future<void> onLoad() async {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    final heartWidth = pixelList[0].length * pixelSize;
    final heartHeight = pixelList.length * pixelSize;
    final offsetX = (screenWidth - heartWidth) / 2;
    final offsetY = (screenHeight - heartHeight) / 2;

    for (var y = 0; y < pixelList.length; y++) {
      for (var x = 0; x < pixelList[y].length; x++) {
        if (pixelList[y][x] != 0) {
          const double baseValue = 1;
          final double healthFactor = baseValue + ((pixelList[y][x] / 255.0) * gameRef.level);
          final int roundedHealth = healthFactor.round();
          final Color colorFactor = Color.lerp(Colors.red, Colors.green, pixelList[y][x] / 255.0)!;
          final pixel = Pixel(incrementMoney: incrementMoney, health: roundedHealth, color: colorFactor)
            ..position.setValues(x * pixelSize + offsetX, y * pixelSize + offsetY);
          add(pixel);
          gameRef.activePixelCount++;
        }
      }
    }
  }
}

class Pixel extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame>, TapCallbacks {
  Pixel({required this.incrementMoney, this.health = 1, this.color = Colors.red});
  final VoidCallback incrementMoney;
  int health;
  bool doesAudioPlay = false;
  final Color color;

  @override
  Future<void> onLoad() async {
    size.setValues(pixelSize, pixelSize);
  }

  @override
  void onTapUp(TapUpEvent event) {
    health -= gameRef.tapStrength;
    if (health <= 0) {
      incrementMoney();
      shatter();
      removeFromParent();
    }
  }

  Future<void> startAudioPlayer() async {
    print('startAudioPlayer: doesAudioPlay: $doesAudioPlay');
    if (doesAudioPlay == true) return;

    doesAudioPlay = true;
    gameRef.laserBeamAudioPool?.start(volume: 0.5);

    await Future.delayed(const Duration(seconds: 1));
    doesAudioPlay = false;
  }

  void shatter() {
    const pieceCount = 12;
    final random = Random();

    for (var i = 0; i < pieceCount; i++) {
      final piece = ShatteredPiece(
        initialPosition: position.clone(),
        audioHandler: startAudioPlayer,
        color: color,
      );
      gameRef.add(piece);

      // Random target position at the bottom
      final targetX = position.x + (random.nextDouble() - 0.5) * 200;
      final targetY = gameRef.size.y - ShatteredPiece.pieceSize;

      final rotateEffect = RotateEffect.by(
        random.nextDouble() * 2 * pi, // Random rotation in radians
        EffectController(
          duration: 2,
        ),
      );
      piece.add(rotateEffect);

      // Apply a MoveEffect to animate the pieces falling to the random position
      final fallEffect = MoveEffect.to(
        Vector2(targetX, targetY),
        EffectController(
          duration: 1.5,
          curve: Curves.fastOutSlowIn,
        ), // will links und rechts eine art strahler wie in star track, dass die teile auf den boden auffängt und dann schreddert
      );
      piece.add(fallEffect);
    }
  }

  double randomSigned() => (Random().nextDouble() - 0.5) * 2;

  @override
  void render(Canvas canvas) {
    final newOpacity = (health / 1).clamp(0.1, 1.0);
    final newColor = color.withOpacity(newOpacity);

    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = newColor);
    canvas.drawRect(
      size.toRect(),
      Paint()
        ..color = const Color.fromARGB(255, 0, 0, 0)
        ..style = PaintingStyle.stroke,
    );

    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      children: [
        TextSpan(text: health.toStringAsFixed(0)),
      ],
    );

    TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();

    // Calculate the coordinates for the center of the text
    double x = (size.x / 2) - (textPainter.width / 2);
    double y = (size.y / 2) - (textPainter.height / 2);

    textPainter.paint(
      canvas,
      Offset(x, y),
    );
  }
}

class ShatteredPiece extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame> {
  ShatteredPiece({required this.initialPosition, required this.audioHandler, this.color = Colors.red});

  static const pieceSize = 20.0;
  static const beamHeight = 70.0;
  final Vector2 initialPosition;
  final Function audioHandler;
  final Color color;

  @override
  Future<void> onLoad() async {
    size.setValues(pieceSize, pieceSize);
    position.setFrom(initialPosition);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (position.y >= gameRef.size.y - pieceSize - beamHeight) {
      removeFromParent();
      await audioHandler();
    }
  }
}
