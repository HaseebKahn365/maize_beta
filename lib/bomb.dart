import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bomb extends SpriteComponent {
  static const bombSize = 12.0;

  Bomb({position})
      : super(
          position: position,
        ) {}

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // The sprite is automatically rendered at the bomb's position
    //add a black rectangle

    final bombPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    canvas.drawRect(size.toRect(), bombPaint);
  }
}
