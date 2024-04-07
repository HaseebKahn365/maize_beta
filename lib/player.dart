import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/flame_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

//the player should be able to readjust its initaial position when the user holds the screen and moves the device. this will give the user a better and comfortable experience when playing the game allowing the user to take a break.

class Player extends PositionComponent with TapCallbacks {
  Color _color = Colors.white;
  final _playerPaint = Paint();

  Player({
    this.playerRadius = 35,
    required this.initialPosition,
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
      _velocity = Vector2(event.x, -event.y);

      //set the initial position of the player
      initialPosition = Vector2(event.x, -event.y);
    });

    super.onMount();
  }

  late Vector2 initialPosition;
  var newPosition = Vector2.zero();

  @override
  void update(double dt) {
    newPosition += _velocity * dt * 1000;
    position += (newPosition - initialPosition) * dt;

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

    final text = 'x: ${_velocity.x.toStringAsFixed(2)}\ny: ${_velocity.y.toStringAsFixed(2)}';
    final textStyle = TextStyle(
      color: Colors.white,
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
    textPainter.paint(canvas, Offset(100, 0));
  }
}
