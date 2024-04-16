import 'package:flutter/material.dart';
import 'package:maize_beta/Components/Collectable_Logic.dart';

class Diamond extends Collectable {
  Diamond({position, size, int score = 300}) : super(position: position, size: size, icon: Icons.diamond, color: Colors.white, score: 300);

  @override
  void _affectScore() {
    super.game.incrementScore(300);
  }
}
