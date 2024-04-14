//this is similar to the coollectable class but on colliding this we shall end the game

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maize_beta/Components/Collectable_Logic.dart';

class Trophy extends Collectable {
  Trophy({position, size})
      : super(
          position: position,
          size: size,
          icon: Icons.emoji_events,
          color: Colors.yellow,
          score: 1000,
        );

  @override
  void affectScore() {
    gameRef.showStartOverlay.value = true;
  }

  int _updateCounter = 0;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  void update(double dt) {
    super.update(dt);

    _updateCounter++;
    if (_updateCounter >= 20) {
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      _updateCounter = 0;
    }
  }
}
