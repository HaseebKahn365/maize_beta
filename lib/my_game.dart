import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/levels/level1.dart';

class MyGame extends FlameGame {
  late final CameraComponent cam;

  //PUSE THE ENGINE METHOD
  void pause() {
    pauseEngine();
  }

  //in the constructor we pause the engine
  MyGame() {
    pauseEngine();
  }

  //RESUME THE ENGINE METHOD

  void resume() {
    resumeEngine();
  }

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
    //casche the audio
    //start the timer

    await FlameAudio.audioCache.loadAll(['collectable.wav', 'laserShoot.wav']);

    return super.onLoad();
  }

  final ValueNotifier<int> life = ValueNotifier(100);

  final ValueNotifier<int> timeElapsed = ValueNotifier(0);

  final ValueNotifier<int> score = ValueNotifier(0);

  //a boolean valuenotifier for showing the game start overlay
  final ValueNotifier<bool> showStartOverlay = ValueNotifier(true);

  //a boolean valuenotifier for showing the game over overlay
  final ValueNotifier<bool> showGameOverOverlay = ValueNotifier(false);

  //a boolean valuenotifier for showing the paused overlay
  //pause means that we are just keeping the ball in its position and not moving it

  final ValueNotifier<bool> showPausedOverlay = ValueNotifier(true);

  //infinite recenter

  //reset the timer
  void resetTimer() {
    timeElapsed.value = 0;
  }

  void incrementTimer() {
    timeElapsed.value += 1;
  }

  void incrementScore(int value) {
    score.value += value;
  }

  Future<void> increaseLife() async {
    print('increasing life');
    if (life.value < 100) {
      int neededLife = 100 - life.value;
      if (neededLife > 10) {
        neededLife = 10;
      }
      for (int i = 0; i < neededLife; i++) {
        await Future.delayed(const Duration(milliseconds: 10), () {
          life.value += 1;
        });
      }
    }
  }

  void decreaseLife() {
    if (life.value > 0) {
      life.value -= 1;
      print('decreasing life');
    }
  }

  void startGame() {
    showStartOverlay.value = false;
    resume();
  }
}
