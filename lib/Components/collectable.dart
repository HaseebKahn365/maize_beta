import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

class Collectable extends SpriteAnimationComponent with HasGameRef<MyGame> {
  final String collectable;

  Collectable({position, size, this.collectable = 'heart'})
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  final double stepTime = 0.05;

  @override
  // TODO: implement priority
  int get priority => 21;

//add a heart material icon

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final icon = Icons.favorite; // The heart icon
    final textSpan = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 20, // The size of the icon
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: Colors.white, // The color of the icon
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final relativePosition = size / 2; // Calculate the relative position

    textPainter.paint(canvas, relativePosition.toOffset()); // Use the relative position

    if (showOnce) {
      showOnce = false;
      print('rendering collectable');
      print(position);
      print(size);
    }
  }

  bool showOnce = true;
}
