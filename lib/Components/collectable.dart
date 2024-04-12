// import 'dart:async';
// import 'dart:math';

// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/particles.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:maize_beta/my_game.dart';

// class Collectable extends SpriteAnimationComponent with HasGameRef<MyGame>, CollisionCallbacks {
//   final IconData icon;
//   final Color color;

//   Collectable({position, size, required this.icon, required this.color})
//       : super(
//           position: position,
//           size: size,
//           anchor: Anchor.center,
//         );

//   final double stepTime = 0.05;
//   bool collided = false;

//   @override
//   Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
//     print('OnCollision call with player detected');
//     if (!collided) {
//       _addBlastParticleEffect();
//       gameRef.increaseLife();
//       _affectScore();
//       collided = true;
//       FlameAudio.play('collectable.wav');

//       await Future.delayed(Duration(milliseconds: 1000));
//       removeFromParent();
//     }

//     super.onCollision(intersectionPoints, other);
//   }

//   void _affectScore() async {
//     game.incrementScore(100);
//   }

//   @override
//   FutureOr<void> onLoad() {
//     add(RectangleHitbox(
//       position: size,
//       anchor: Anchor.bottomRight,
//       size: Vector2(16, 16),
//       collisionType: CollisionType.passive,
//     ));
//     return super.onLoad();
//   }

//   @override
//   int get priority => 1;

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     final textSpan = TextSpan(
//       text: String.fromCharCode(icon.codePoint),
//       style: TextStyle(
//         fontSize: 18,
//         fontFamily: icon.fontFamily,
//         package: icon.fontPackage,
//         color: (collided) ? Colors.black.withOpacity(0) : color,
//       ),
//     );
//     final textPainter = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.rtl,
//     );
//     textPainter.layout();
//     final relativePosition = Vector2(0, 0);

//     textPainter.paint(canvas, relativePosition.toOffset());
//   }

//   void _addBlastParticleEffect() {
//     final random = Random();
//     ParticleSystemComponent particleSystem = ParticleSystemComponent(
//       anchor: Anchor.center,
//       particle: Particle.generate(
//         count: 10,
//         lifespan: 2,
//         generator: (i) => AcceleratedParticle(
//           acceleration: Vector2(random.nextDouble() * 100 - 50, random.nextDouble() * 100 - 50),
//           speed: Vector2(random.nextDouble() * 200 - 50, random.nextDouble() * 200 - 50),
//           child: CircleParticle(
//             radius: 0.07 + random.nextDouble(),
//             paint: Paint()
//               ..color = Color.fromRGBO(
//                 random.nextInt(256),
//                 random.nextInt(256),
//                 random.nextInt(256),
//                 1,
//               ),
//           ),
//         ),
//       ),
//     );

//     add(particleSystem);
//   }
// }
