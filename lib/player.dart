import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/flame_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

//the player should be able to readjust its initaial position when the user holds the screen and moves the device. this will give the user a better and comfortable experience when playing the game allowing the user to take a break.

class Player extends PositionComponent with HasGameRef<MyGame>, TapCallbacks {
  Color _color = Colors.white;
  final _playerPaint = Paint();

  Player({
    this.playerRadius = 35,
  }) : super(
          position: Vector2.all(150),
          priority: 20,
        ) {
    initialPosition = position;
  }

  final double playerRadius;
  Vector2 _velocity = Vector2.zero();
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _velocity = Vector2(event.y, event.x);

      //set the initial position of the player
      initialPosition = Vector2(event.y, event.x);
    });

    super.onMount();
  }

  bool cond = false;

  @override
  void onLongTapDown(TapDownEvent event) {
    // Set cond to true to start updating newPosition
    cond = !cond;
    super.onLongTapDown(event);
  }

  late Vector2 initialPosition;
  var newPosition = Vector2.zero();

  @override
  void update(double dt) {
    if (cond) {
      newPosition = initialPosition;
    }

    newPosition += _velocity * dt * 1500;
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
