import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:maize_beta/player.dart';

class Level extends World {
  late TiledComponent level;
  late Player player;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));
    player = Player(initialPosition: Vector2(100, 100), playerRadius: 12);

    add(player);
    add(level);

    return super.onLoad();
  }
}
