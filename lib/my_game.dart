import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:maize_beta/levels/level1.dart';

class MyGame extends FlameGame {
  late final CameraComponent cam;

  final som = Level();

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    cam = CameraComponent.withFixedResolution(
      world: som,
      height: 360,
      width: 640,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, som]);

    return super.onLoad();
  }
}
