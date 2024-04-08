import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/collision_block.dart';
import 'package:sensors_plus/sensors_plus.dart';

//the player should be able to readjust its initaial position when the user holds the screen and moves the device. this will give the user a better and comfortable experience when playing the game allowing the user to take a break.

class Player extends PositionComponent {
  Color _color = Colors.white;
  final _playerPaint = Paint();
  final motionIntensity = 500;

  //these are the collision blocks that the player will collide with

  List<CollisionBlock> collisionBlocks = [];

  Player({
    this.playerRadius = 20,
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
  void update(double dt) async {
    tempPosition = position.clone();
    newPosition += _velocity * dt * motionIntensity.toDouble();
    position += (newPosition - initialPosition) * dt;

    //check if the player is colliding with any of the collision blocks
    for (final block in collisionBlocks) {
      if (collidesWith(block)) {
        _color = Colors.red;
        position = tempPosition;

        //add collision sparks to the current point of intersection using the particle system

        _addParticle();

        //making the collision sound

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
          center: ((newPosition / 10).toOffset() + (newPosition / 10).toOffset()) + (Offset(playerRadius, 0)),
          radius: playerRadius * 1.5, //
        )),
      Colors.white,
      10, // blur radius
      true,
    );
    _drawVelocityArrow(canvas);
  }

  //collides with the collision block method
  bool collidesWith(CollisionBlock block) {
    final playerRect = toRect();
    final blockRect = block.toRect();

    return playerRect.overlaps(blockRect);
  }

  void recenterThePlayer() {
    //when i collide with a block, i should be able to continue from the point of collision
    newPosition = initialPosition;
    print('Player recentered!');
  }

  void _drawVelocityArrow(
    Canvas canvas,
  ) {
    final Offset start = ((size / 2)).toOffset();
    final Offset end = (size / 2).toOffset() + (newPosition / 10).toOffset();

    // Offset for the arrowhead
    final double arrowOffset = 20;
    final Offset arrowEnd = end.translate(arrowOffset * cos(atan2(end.dy - start.dy, end.dx - start.dx)), arrowOffset * sin(atan2(end.dy - start.dy, end.dx - start.dx)));

    // Calculate the angle of the line
    double angle = atan2(arrowEnd.dy - start.dy, arrowEnd.dx - start.dx);

    // Draw the arrowhead
    final double arrowLength = 5;
    final double arrowWidth = 2 * 3.1415 / 5; // 24 degrees
    // Calculate the start and sweep angles for the arc
    double startAngle = angle - arrowWidth;
    double sweepAngle = 2 * arrowWidth;

    // Calculate the radius of the arc
    double radius = arrowLength / sin(arrowWidth);

    // Calculate the center of the arc
    Offset center = arrowEnd.translate(-radius * cos(angle), -radius * sin(angle));

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  void _addParticle() {
    final random = Random();
    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 1, // Increase count for more sparks
        lifespan: 1, // Increase lifespan for longer-lasting sparks
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50), // Randomize acceleration for more chaotic sparks
          speed: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50), // Randomize speed for more chaotic sparks
          child: CircleParticle(
            radius: 0.1 + random.nextDouble(), // Decrease radius for smaller, more spark-like particles
            paint: Paint()..color = Colors.yellow, // Change color to yellow for more spark-like color
          ),
        ),
      ),
    );

    add(particleSystem);
  }
}
