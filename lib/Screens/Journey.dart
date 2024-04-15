// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maize_beta/TimelineComponents/mytimeline_tile.dart';

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
          MyTimelineTile(
            isFirst: true,
            isLast: false,
            isPast: false,
            child: Text('Level 3'),
          ),
          MyTimelineTile(
            isFirst: false,
            isLast: false,
            isPast: false,
            child: Text('Level 2'),
          ),
          MyTimelineTile(
            isFirst: false,
            isLast: true,
            isPast: true,
            child: BeautifulEventCard(),
          ),
        ],
      ),
    );
  }
}

class BeautifulEventCard extends StatefulWidget {
  const BeautifulEventCard({super.key});

  @override
  State<BeautifulEventCard> createState() => _BeautifulEventCardState();
}

class _BeautifulEventCardState extends State<BeautifulEventCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/flags/ke.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kenya'),
                Text('Score: 100'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/flags/ug.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Uganda'),
                Text('Score: 90'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/flags/tz.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanzania'),
                Text('Score: 80'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
