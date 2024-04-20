import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/levels/level.dart';

class MyGame extends FlameGame {
  late final CameraComponent cam;
  final int selectedLevel;

  MyGame({required this.selectedLevel}) {
    pauseEngine();
  }

  //PUSE THE ENGINE METHOD
  void pause() {
    pauseEngine();
  }

  //RESUME THE ENGINE METHOD

  void resume() {
    resumeEngine();
  }

  late final som;

  @override
  FutureOr<void> onLoad() async {
    som = Level(leveIndex: selectedLevel);
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

    await FlameAudio.audioCache.loadAll(['collectable.wav', 'collide.wav', 'gameover.wav']);

    return super.onLoad();
  }

  final ValueNotifier<int> life = ValueNotifier(100);

  final ValueNotifier<int> timeElapsed = ValueNotifier(0);

  final ValueNotifier<int> score = ValueNotifier(0);

  //a boolean valuenotifier for showing the game start overlay
  final ValueNotifier<bool> showStartOverlay = ValueNotifier(true);

  //a boolean valuenotifier for showing the game over overlay
  final ValueNotifier<bool> gameLevelCompleted = ValueNotifier(false);

  //a int valuenotifier for diamonds count
  final ValueNotifier<int> diamonds = ValueNotifier(0);

  //a int valuenotifier for shrinkers count
  final ValueNotifier<int> shrinkers = ValueNotifier(0);

  //a int valuenotifier for hearts count
  final ValueNotifier<int> hearts = ValueNotifier(0);

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
      //when the life becomes zero we are gonna navigate to the GameResultScreen with material pushReplacement
      print('decreasing life');
    }
  }

  void startGame() {
    showStartOverlay.value = false;
    resume();
  }
}
