//here is the new design for the collectables thatt will be used in the game.

/*
There is a parent class called Collectable which contains 
Icon
Color

affectScore()


from this parent class we extend three classes called Diamond, Heart, and Shrinker

the Diamond class will have a diamond icon and a white color and will increase score by 300.

the Heart class will have a heart icon and a red color and will increase life by 10.and will increase score by 100.

the Shrinker class will have a shrinker icon and a blue color and will decrease the size of the player by hisSize/2.

 */

import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

abstract class Collectable extends SpriteAnimationComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final IconData icon;
  final Color color;
  final int score;

  Collectable({position, size, required this.icon, required this.color, this.score = 100})
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
      _addBlastParticleEffect();
      _affectScore();

      collided = true;
      FlameAudio.play('collectable.wav');

      await Future.delayed(Duration(milliseconds: 1000));
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }

  void _affectScore() async {
    game.incrementScore(score);
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
  int get priority => 1;

//add a heart material icon

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textSpan = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 18, // The size of the icon
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        //proper bg color needed;
        color: (collided) ? Colors.black.withOpacity(0) : color, // The color of the icon
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    final relativePosition = Vector2(0, 0); // Calculate the relative position

    textPainter.paint(canvas, relativePosition.toOffset()); // Use the relative position

    //check if collided then set the color to black
  }

  void _addBlastParticleEffect() {
    final random = Random();
    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      anchor: Anchor.center,
      particle: Particle.generate(
        count: 10, // Increase count for more sparks
        lifespan: 2, // Increase lifespan for longer-lasting sparks
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50), // Randomize acceleration for more chaotic sparks
          speed: Vector2(random.nextDouble() * 200 - 50, random.nextDouble() * 200 - 50), // Randomize speed for more chaotic sparks
          child: CircleParticle(
            radius: 0.07 + random.nextDouble(), // Decrease radius for smaller, more spark-like particles
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
