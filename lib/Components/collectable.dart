import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

class Collectable extends SpriteAnimationComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final String collectable;

  Collectable({position, size, this.collectable = 'heart'})
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  final double stepTime = 0.05;
  bool collided = false;

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    print('OnCollision call with player detected');
    if (!collided) {
      //add shrink animation to the coollectable then _addBlastParticleEffect
      _addBlastParticleEffect();
      collided = true;
      await Future.delayed(Duration(milliseconds: 1000));
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }

  Future<void> _shrinkAnimation() async {
    final initialSize = size.clone();
    final initialPosition = position.clone();
    final stepSize = initialSize / 10;
    final stepTime = 0.05;

    for (var i = 0; i < 10; i++) {
      size -= stepSize;
      position += stepSize / 2;
      await Future.delayed(Duration(milliseconds: (stepTime * 1000).round()));
    }

    size = initialSize;
    position = initialPosition;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: size,
      anchor: Anchor.bottomRight,
      size: Vector2(16, 16),
      collisionType: CollisionType.passive,
    ));
    return super.onLoad();
  }

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
        fontSize: 18, // The size of the icon
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: Colors.white, // The color of the icon
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    final relativePosition = Vector2(0, 0); // Calculate the relative position

    textPainter.paint(canvas, relativePosition.toOffset()); // Use the relative position
  }

  void _addBlastParticleEffect() {
    final random = Random();
    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      anchor: Anchor.center,
      particle: Particle.generate(
        count: 100, // Increase count for more sparks
        lifespan: 1, // Increase lifespan for longer-lasting sparks
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(random.nextDouble() * 220 - 50, random.nextDouble() * 220 - 50), // Randomize acceleration for more chaotic sparks
          speed: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50), // Randomize speed for more chaotic sparks
          child: CircleParticle(
            radius: 0.1 + random.nextDouble(), // Decrease radius for smaller, more spark-like particles
            paint: Paint()
              ..color = Color.fromRGBO(
                random.nextInt(256), // Random red
                random.nextInt(256), // Random green
                random.nextInt(256), // Random blue
                1, // Opaque
              ), // Random color for each particle
          ),
        ),
      ),
    );

    add(particleSystem);
  }
}
