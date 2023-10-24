import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

double pixelSize = 40.0;

class PixelDemolitionTycoonGame extends FlameGame {
  int activePixelCount = 0;
  int tapStrength = 1;
  int level = 1;
  double money = 0;
  List<List<List<int>>> levels = [];
  final Map<double, double> shatterPositions = {}; // Map of X position to Y position
  AudioPool? laserBeamAudioPool;

  final List<List<int>> heart = [
    [0, 1, 1, 0, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  final List<List<int>> circle = [
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 0, 0, 1, 1, 0],
    [1, 1, 0, 0, 0, 0, 1, 1],
    [1, 0, 0, 1, 1, 0, 0, 1],
    [1, 0, 0, 1, 1, 0, 0, 1],
    [1, 1, 0, 0, 0, 0, 1, 1],
    [0, 1, 1, 0, 0, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
  ];

  @override
  Future<void> onLoad() async {
    levels.addAll([heart, circle]);
    final currentPixelModel = PixelModel(incrementMoney: incrementMoney, pixelList: levels[level - 1]);
    add(currentPixelModel);
    laserBeamAudioPool = await FlameAudio.createPool('laser_beam.mp3', minPlayers: 1, maxPlayers: 1);
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
        if (pixelList[y][x] == 1) {
          final pixel = Pixel(incrementMoney: incrementMoney, health: 1.0 * gameRef.level)
            ..position.setValues(x * pixelSize + offsetX, y * pixelSize + offsetY);
          add(pixel);
          gameRef.activePixelCount++;
        }
      }
    }
  }
}

class Pixel extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame>, TapCallbacks {
  Pixel({required this.incrementMoney, this.health = 1.0});
  final VoidCallback incrementMoney;
  double health;
  bool doesAudioPlay = false;

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
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color.fromARGB(255, 255, 0, 0));
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
  ShatteredPiece({required this.initialPosition, required this.audioHandler});

  static const pieceSize = 20.0;
  static const beamHeight = 70.0;
  final Vector2 initialPosition;
  final Function audioHandler;

  @override
  Future<void> onLoad() async {
    size.setValues(pieceSize, pieceSize);
    position.setFrom(initialPosition);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.red;
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
