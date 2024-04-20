// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maize_beta/TimelineComponents/mytimeline_tile.dart';
import 'package:maize_beta/main.dart';

/*
Here we are going to have a timeline widget that will indicate the levels that the user has completed. and will also have containers which will allow the user to view the toop players
for that very level. the top players data will be loaded from firebase firestore.
the container for each level will have a avatar, name and the score of the player.
the avatar will be a circle showing the country flag of the player.
 */

//creating a global list of GenericLevelWidget use the following people as the toppers:
//1. Abdul Haseeb with country code 'ps'
//2. Tayyab Ahmand with country code 'ps'
//3. Hamza Fayaz with country code 'pk'
//4. Muhammad Bilal with country code 'pk'
//5. Muhammad Hammad with country code 'pk'
//6. Kanetkar Saab with country code 'in'
//7. Heisenberg with country code 'us'

//use the above toppers randomly

//initially all the levels except level1 will be collapsed and the user will have to tap on the level to expand it and see the toppers

List<GenericLevelWidget> levels = [
  GenericLevelWidget(
    levelName: 'Level 1',
    myPosition: 1,
    toppers: [
      //randomized toppers
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'in', name: 'Kaushik', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 2',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 3',
    myPosition: 1,
    toppers: [
      //randomized toppers
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 4',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 5',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 6',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 7',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 8',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 9',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 100, life: 3),
    ],
    isPast: true,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 10',
    myPosition: 1,
    toppers: [
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 100, life: 3),
    ],
    isPast: false,
    isCollapsed: true,
  ),
];

class Journey extends StatefulWidget {
  const Journey({
    super.key,
  });

  @override
  State<Journey> createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
  bool isPast = true;
  bool isCollapsed = true;

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

            //use the spread operator on the list of GenericLevelWidget to create the timeline tiles
            ...levels.map((level) {
              return MyTimelineTile(
                isFirst: false,
                isLast: false,
                isPast: level.isPast,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(level.levelName),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text('My Position: ${level.myPosition}'),
                        )
                      ],
                    ),
                    if (!level.isCollapsed)
                      ...level.toppers.map((topper) {
                        return BeautifulEventCard(
                          countryCode: topper.countryCode,
                          name: topper.name,
                          score: topper.timeInSeconds,
                        );
                      }).toList(),
                    //create a play button using row widget and center alligned
                    //the play button will be a raised button with a text play

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //elevated button with text play
                        ElevatedButton(
                          onPressed: !level.isPast
                              ? null
                              : () {
                                  print('play');
                                  //use material route to navigate to MyApp(selectedLevel: 1)

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(selectedLevel: 1)));
                                },
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                size: 30,
                              ),
                              Text('  Play'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

//Here we define a class to represent the Timeline tile
/*
Attributes:
isFirst
isLast
isPast

Topper person1;
Topper person2;
Topper person3;

isCollapsed

we will create a list of instances of this class and then use them in the journey widget using the spread operatoor
 */

class GenericLevelWidget {
  final String levelName;
  final int myPosition;
  final List<Topper> toppers;
  final bool isPast;
  final bool isCollapsed;

  GenericLevelWidget({
    required this.levelName,
    required this.myPosition,
    required this.toppers,
    required this.isPast,
    required this.isCollapsed,
  });
}

class Topper {
  final String countryCode;
  final String name;
  final int timeInSeconds;
  final int life;

  Topper({
    required this.countryCode,
    required this.name,
    required this.timeInSeconds,
    required this.life,
  });
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
              blurRadius: 7,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CircleAvatar(
          maxRadius: 20,
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
          backgroundImage: NetworkImage('https://flagcdn.com/w160/$countryCode.jpg'),
        ),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      subtitle: Text(score.toString()),
      trailing: Icon(Icons.arrow_forward_ios, size: 15),
      onTap: () {
        print('tapped');
      },
    );
  }
}
