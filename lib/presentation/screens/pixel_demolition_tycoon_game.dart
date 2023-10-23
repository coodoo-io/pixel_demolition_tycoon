import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

double pixelSize = 40.0;

class PixelDemolitionTycoonGame extends FlameGame {
  int activePixelCount = 0;
  int doubleTapStrength = 1;
  int level = 1;
  double money = 0;
  InformationHud hud = InformationHud();

  @override
  Future<void> onLoad() async {
    final heart = PixelHeart(incrementMoney: incrementMoney);
    add(heart);
    add(hud);
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
      final heart = PixelHeart(incrementMoney: incrementMoney);
      add(heart);
    }
  }

  void upgradeTapStrength() {
    if (money >= 100) {
      money -= 100;
      doubleTapStrength++;
    }
  }
}

class InformationHud extends TextBoxComponent with HasGameRef<PixelDemolitionTycoonGame> {
  InformationHud();

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      children: [
        TextSpan(text: 'Level: ${gameRef.level}'),
        const TextSpan(text: '     '),
        TextSpan(text: 'Money: ${gameRef.money}'),
      ],
    );

    TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();

    double x = gameRef.size.x - textPainter.width - 10; // Positioning 10 pixels from the right edge
    double y = 10; // Positioning 10 pixels from the top edge

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  void drawBackground(Canvas c) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = const Color.fromARGB(255, 0, 0, 0));
  }
}

class PixelHeart extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame> {
  PixelHeart({required this.incrementMoney});

  final VoidCallback incrementMoney;
  final List<List<int>> heartShape = [
    [0, 1, 1, 0, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  @override
  Future<void> onLoad() async {
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;
    final heartWidth = heartShape[0].length * pixelSize;
    final heartHeight = heartShape.length * pixelSize;
    final offsetX = (screenWidth - heartWidth) / 2;
    final offsetY = (screenHeight - heartHeight) / 2;

    for (var y = 0; y < heartShape.length; y++) {
      for (var x = 0; x < heartShape[y].length; x++) {
        if (heartShape[y][x] == 1) {
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

  @override
  Future<void> onLoad() async {
    size.setValues(pixelSize, pixelSize);
  }

  @override
  void onTapUp(TapUpEvent event) {
    health -= gameRef.doubleTapStrength;
    if (health <= 0) {
      incrementMoney();
      removeFromParent();
    }
  }

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
  }
}
