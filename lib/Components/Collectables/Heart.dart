import 'package:flutter/material.dart';
import 'package:maize_beta/Components/Collectable_Logic.dart';

class Heart extends Collectable {
  Heart({position, size})
      : super(
          position: position,
          size: size,
          icon: Icons.favorite,
          color: Colors.red,
        );

  @override
  void affectScore() {
    game.incrementScore(100);
    game.increaseLife();
  }
}
