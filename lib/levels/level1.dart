import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/Components/collectable.dart';
import 'package:maize_beta/Components/collision_block.dart';
import 'package:maize_beta/Components/player.dart';

class Level extends World with TapCallbacks, HasCollisionDetection {
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

    _spawningObjects();

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
        }
      }
      player.collisionBlocks = collisionBlocks;
    }

    // return super.onLoad();
  }

  void _spawningObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

// Each one of the spawn points coming from the map

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.type) {
          case 'Player':
            //we need to accomodate for the player size too.

            player = Player(playerRadius: 6, position: Vector2(spawnPoint.x, spawnPoint.y));
            add(player);
            break;

          case 'Fruit':
            print('fruit found');
            final collectable = Collectable(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              icon: Icons.favorite,
              color: Colors.red,
            );
            add(collectable);
        }
      }
    }
  }
}
