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
          position: Vector2(200, 200),
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
    position += _velocity * dt * 1000;
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
  }
}
