import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:maize_beta/levels/level1.dart';

class MyGame extends FlameGame {
  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    debugMode = true;
    cam = CameraComponent.withFixedResolution(
      world: world,
      height: 360,
      width: 640,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
