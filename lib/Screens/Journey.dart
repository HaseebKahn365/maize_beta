import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maize_beta/Screens/leaderboard.dart';
import 'package:maize_beta/TimelineComponents/mytimeline_tile.dart';
import 'package:timeline_tile/timeline_tile.dart';

/*
Here we are going to have a timeline widget that will indicate the levels that the user has completed. and will also have containers which will allow the user to view the toop players
for that very level. the top players data will be loaded from firebase firestore.
the container for each level will have a avatar, name and the score of the player.
the avatar will be a circle showing the country flag of the player.
 */

class Journey extends StatefulWidget {
  const Journey({
    super.key,
  });

  @override
  State<Journey> createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          // Timeline widget
          // Container for each level
          // Avatar
          // Name
          // Score

          //three tiles for now
          MyTimelineTile(isFirst: true, isLast: false, isPast: false),
          MyTimelineTile(isFirst: false, isLast: false, isPast: false),
          MyTimelineTile(isFirst: false, isLast: true, isPast: true),
        ],
      ),
    );
  }
}
