import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/Components/Collectable_Logic.dart';
import 'package:maize_beta/Components/collision_block.dart';
import 'package:maize_beta/my_game.dart';
import 'package:sensors_plus/sensors_plus.dart';

//the player should be able to readjust its initaial position when the user holds the screen and moves the device. this will give the user a better and comfortable experience when playing the game allowing the user to take a break.
enum Direction { updown, leftright, invalid }

class Player extends PositionComponent with CollisionCallbacks, HasGameRef<MyGame> {
  Color _color = Colors.white;
  final _playerPaint = Paint();
  final motionIntensity = 700;

  //these are the collision blocks that the player will collide with

  List<CollisionBlock> collisionBlocks = [];

  Player({this.playerRadius = 20, position})
      : super(
          position: position,
          anchor: Anchor.topLeft,
          priority: 20,
        ) {
    // debugMode = true;
  }

  double playerRadius;
  Vector2 _velocity = Vector2.zero();
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  //shrinker
  void shrink() {
    print('Player is shrinking!');
    playerRadius = playerRadius / 2;
  }

  //addinghitbox
  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: size,
      anchor: Anchor.topLeft,
      size: Vector2(playerRadius * 2, playerRadius * 2),
      collisionType: CollisionType.active,
    ));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Collectable) {}
    super.onCollision(intersectionPoints, other);
  }

  bool showGuideArc = true;

//gyroninit
  @override
  void onMount() {
    super.onMount();
    size = Vector2.all(playerRadius * 2);

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _velocity = Vector2(event.x, -event.y);

      //set the initial position of the player
      initialPosition = Vector2(event.x, -event.y);
    });
  }

  late Vector2 initialPosition = Vector2.zero();
  var newPosition = Vector2.zero();

  var tempPosition;

//update position or slide on collision
  @override
  void update(double dt) async {
    super.update(dt);
    tempPosition = position.clone();

    if (game.showPausedOverlay.value == true) {
      newPosition += _velocity * dt * motionIntensity.toDouble();
      position += (newPosition - initialPosition) * dt;
    }

    //check if the player is colliding with any of the collision blocks
    for (final block in collisionBlocks) {
      if (collidesWith(block)) {
        final pointOfCollision = newPosition; //we want to slide rather than stopping the player
        _color = Colors.red;

        //finding direction:
        final Direction dir = findDirection(tempPosition, block);

        switch (dir) {
          case Direction.leftright:
            print('Collision on left or right! detected');
            newPosition = Vector2(initialPosition.x, pointOfCollision.y);
            break;

          case Direction.updown:
            print('Collision on up or down! detected');
            newPosition = Vector2(pointOfCollision.x, initialPosition.y);
            break;

          case Direction.invalid:
            recenterThePlayer();
            print('Invalid direction! detected');
            break;
        }

        _addParticle();

        //making the collision sound
        _playFutureAudio();

        //reduce the life
        gameRef.decreaseLife();

        break;
      } else {
        //find the int distance between two vector2s distance(newPosition - initialPosition)
        final distance = (newPosition).distanceTo(initialPosition);
        if (distance > 170) {
          // print(distance);
          game.incrementScore(1);
        }
        _color = Colors.white;
      }
    }
  }

  Direction findDirection(Vector2 oldPositioin, CollisionBlock block) {
    //finding the central point of collision from rects
    final playerRect = toRect();
    final blockRect = block.toRect();

    // Calculate the player's center
    final double playerCenterX = playerRect.left + playerRect.width / 2;
    final double playerCenterY = playerRect.top + playerRect.height / 2;

    // Check if the player's center is within the block's boundaries
    bool isWithinBlockX = playerCenterX >= blockRect.left && playerCenterX <= blockRect.right;
    bool isWithinBlockY = playerCenterY >= blockRect.top && playerCenterY <= blockRect.bottom;

    // Determine the direction of the collision
    if (isWithinBlockY) {
      // If the player's center is within the block's top and bottom boundaries, it's a left/right collision
      return Direction.leftright;
    } else if (isWithinBlockX) {
      // If the player's center is within the block's left and right boundaries, it's an up/down collision
      return Direction.updown;
    } else {
      // If the player's center is not within the block's boundaries, it's a corner collision
      return Direction.invalid;
    }
  }

  int audioPlayCount = 0; // Counter for the number of times the audio has been played

  void _playFutureAudio() {
    if (audioPlayCount % 8 == 0 || audioPlayCount == 0) {
      // print('Audio played!');
      // Only play the audio if it has been played less than 5 times
      // FlameAudio.play('laserShoot.wav');
      // print('Audio played!');
    }
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
          //dividing the new position by 10 to reduce the shadow length due to the velocity
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
  bool collidesWith(
    PositionComponent block,
  ) {
    final playerRect = toRect();
    final blockRect = block.toRect();

    return playerRect.overlaps(blockRect);
  }

  void recenterThePlayer() {
    //when i collide with a block, i should be able to continue from the point of collision
    print('Player recentered!');
    newPosition = initialPosition;
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

    if (showGuideArc) {
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
  }

  void _addParticle() {
    final random = Random();
    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 1, // Increase count for more sparks
        lifespan: 0.4, // Increase lifespan for longer-lasting sparks
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50), // Randomize acceleration for more chaotic sparks
          speed: Vector2(random.nextDouble() * 200 - 50, random.nextDouble() * 200 - 50), // Randomize speed for more chaotic sparks
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
