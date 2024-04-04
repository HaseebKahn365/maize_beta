import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/flame_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  Color _color = Colors.white;
  final _playerPaint = Paint();

  Player({
    this.playerRadius = 20,
  }) : super(
          position: Vector2.all(150),
          priority: 20,
        ) {}

  final double playerRadius;
  Vector2 _velocity = Vector2.zero();
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _velocity = Vector2(event.y, event.x);
    });

    super.onMount();
  }

  @override
  void update(double dt) {
    position += _velocity * dt * 500;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      _playerPaint..color = _color,
    );

    //add a rectange component on the top that will display the x and y values of the gyroscope sensor

    //initial position of the player is 150,150
    //the displacement vector from the intial point will be used as the velocity of the player
    final text = 'x: ${_velocity.x.toStringAsFixed(2)}\ny: ${_velocity.y.toStringAsFixed(2)}';
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 200,
    );
    textPainter.paint(canvas, Offset(0, 0));
  }
}
