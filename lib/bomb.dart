import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bomb extends SpriteComponent {
  static const bombSize = 32.0;

  Bomb({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(bombSize),
        ) {
    // Load the bomb icon
    Sprite.load('bomb_icon.png').then((sprite) {
      this.sprite = sprite;
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // The sprite is automatically rendered at the bomb's position
  }
}
