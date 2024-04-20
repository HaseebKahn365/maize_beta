import 'package:flutter/material.dart';
import 'package:maize_beta/Components/Collectable_Logic.dart';

class Shrinker extends Collectable {
  Shrinker({position, size})
      : super(
          position: position,
          size: size,
          icon: Icons.remove_circle,
          color: Colors.blue,
        );
  @override
  void affectScore() {
    super.affectScore();
    game.shrinkers.value += 1;
    gameRef.som.player.shrink();
  }
}
