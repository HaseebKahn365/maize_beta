import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:maize_beta/collision_block.dart';
import 'package:maize_beta/player.dart';

class Level extends World with TapCallbacks {
  late TiledComponent level;
  late Player player;

  //on long tap call the recenterPlayer method of the player

  @override
  void onTapDown(TapDownEvent event) {
    player.recenterThePlayer();
  }

  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

// Each one of the spawn points coming from the map

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.type) {
          case 'Player':
            //we need to accomodate for the player size too.

            player = Player(playerRadius: 8, position: Vector2(spawnPoint.x, spawnPoint.y));
            add(player);
            break;
        }
      }
    }

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    add(level);

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'ColllisionRecs':
            print('collision block found');
            final collisionBlock = CollisionBlock(
              Vector2(collision.x, collision.y),
              Vector2(collision.width, collision.height),
            );

            collisionBlocks.add(collisionBlock);
            add(collisionBlock);
            break;

          case 'bomb':
            print('bomb found');
        }
      }
      player.collisionBlocks = collisionBlocks;
    }

    // return super.onLoad();
  }
}
