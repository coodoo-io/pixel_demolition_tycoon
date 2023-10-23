import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

double pixelSize = 20.0;

class PixelDemolitionTycoonGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final heart = PixelHeart();
    add(heart);
  }
}

class PixelHeart extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame> {
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
          final pixel = Pixel()..position.setValues(x * pixelSize + offsetX, y * pixelSize + offsetY);
          add(pixel);
        }
      }
    }
  }
}

class Pixel extends PositionComponent with HasGameRef<PixelDemolitionTycoonGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {
    size.setValues(pixelSize, pixelSize);
  }

  @override
  void onTapUp(TapUpEvent event) {
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color.fromARGB(255, 255, 0, 0));
  }
}
