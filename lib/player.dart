import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/collision_block.dart';
import 'package:sensors_plus/sensors_plus.dart';

//the player should be able to readjust its initaial position when the user holds the screen and moves the device. this will give the user a better and comfortable experience when playing the game allowing the user to take a break.

class Player extends PositionComponent {
  Color _color = Colors.white;
  final _playerPaint = Paint();

  //these are the collision blocks that the player will collide with

  List<CollisionBlock> collisionBlocks = [];

  Player({
    this.playerRadius = 20,
    required this.initialPosition,
  }) : super(
          position: Vector2.all(150),
          priority: 20,
          anchor: Anchor.center,
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

    //modify the hitbox of the player to be circular

    super.onMount();
  }

  late Vector2 initialPosition;
  var newPosition = Vector2.zero();

  var tempPosition;

  @override
  void update(double dt) {
    tempPosition = position.clone();
    newPosition += _velocity * dt * 300;
    position += (newPosition - initialPosition) * dt;

    //check if the player is colliding with any of the collision blocks
    for (final block in collisionBlocks) {
      if (collidesWith(block)) {
        _color = Colors.red;
        position = tempPosition;
        _continueFromCollisionPoint();
        break;
      } else {
        _color = Colors.white;
      }
    }
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
    //add shadow to the player in the direction of the velocity
    canvas.drawShadow(
      Path()
        ..addOval(Rect.fromCircle(
          //dividing the new position by 5 to reduce the shadow length due to the velocity
          center: (newPosition / 10).toOffset() + (newPosition / 10).toOffset(),
          radius: playerRadius * 1.5, //
        )),
      Colors.white,
      10, // blur radius
      true,
    );
  }

  //collides with the collision block method
  bool collidesWith(CollisionBlock block) {
    final playerRect = toRect();
    final blockRect = block.toRect();

    return playerRect.overlaps(blockRect);
  }

  //TODO: reset gyro method
  void _continueFromCollisionPoint() {
    //when i collide with a block, i should be able to continue from the point of collision
    newPosition = initialPosition;
  }
}
