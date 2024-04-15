// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
        child: ListView(
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
              isPast: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Level 1'),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text('My Position: 1'),
                      )
                    ],
                  ),
                  BeautifulEventCard(
                    countryCode: 'pk',
                    name: 'Abdul Haseeb',
                    score: 100,
                  ),
                  BeautifulEventCard(
                    countryCode: 'pk',
                    name: 'Abdul Haseeb',
                    score: 100,
                  ),
                  BeautifulEventCard(
                    countryCode: 'pk',
                    name: 'Abdul Haseeb',
                    score: 100,
                  ),
                ],
              ),
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
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              child: Text('Level 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class BeautifulEventCard extends StatelessWidget {
  final String countryCode;
  final String name;
  final int score;
  const BeautifulEventCard({
    super.key,
    required this.countryCode,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        //add shadow

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
          backgroundImage: NetworkImage('https://flagcdn.com/w160/pk.jpg'),
        ),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      subtitle: Text(score.toString()),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () {},
      ),
    );
  }
}
