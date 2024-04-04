//this the game screen

import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/player.dart';

class FlameScreen extends StatefulWidget {
  const FlameScreen({super.key});

  @override
  State<FlameScreen> createState() => _FlameScreenState();
}

class _FlameScreenState extends State<FlameScreen> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: MyGame());
  }
}

class MyGame extends FlameGame {
  late Player myPlayer;

  MyGame() : super() {
    CameraComponent.withFixedResolution(
      width: 600,
      height: 600,
    );
  }

  @override
  Color backgroundColor() {
    return Colors.red;
  }

  @override
  Future<void> onLoad() async {
    debugMode = true;
    camera.viewfinder.anchor = Anchor.center;
    // Load the player sprite
    add(myPlayer = Player());
  }
}
