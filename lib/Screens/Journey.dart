// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/Screens/main_screen.dart';
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
    isFirst: true,
    myPosition: 1024,
    toppers: [
      //randomized toppers
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 4, life: 100),
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 5, life: 100),
      Topper(countryCode: 'in', name: 'Kaushik', timeInSeconds: 5, life: 100),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 2',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 2, life: 100),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 2, life: 100),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 2, life: 100),
    ],
    isPast: true,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 3',
    myPosition: 1024,
    toppers: [
      //randomized toppers
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 3, life: 100),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 3, life: 100),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 4, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 4',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 5, life: 40),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 8, life: 100),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 8, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 5',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 8, life: 58),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 10, life: 100),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 10, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 6',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 9, life: 100),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 11, life: 100),
      Topper(countryCode: 'us', name: 'Sam Tucker', timeInSeconds: 11, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 7',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 10, life: 100),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 11, life: 100),
      Topper(countryCode: 'us', name: 'Heisenberg', timeInSeconds: 13, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 8',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'ps', name: 'Tayyab Ahmad', timeInSeconds: 10, life: 100),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 13, life: 100),
      Topper(countryCode: 'au', name: 'Temmethy Jr.', timeInSeconds: 13, life: 100),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 9',
    myPosition: 1024,
    toppers: [
      Topper(countryCode: 'pk', name: 'Muhammad Bilal', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'pk', name: 'Muhammad Hammad', timeInSeconds: 100, life: 3),
      Topper(countryCode: 'in', name: 'Kanetkar Saab', timeInSeconds: 100, life: 3),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 10',
    myPosition: 1024,
    isLast: true,
    toppers: [
      Topper(countryCode: 'ps', name: 'Abdul Haseeb', timeInSeconds: 56, life: 88),
      Topper(countryCode: 'pk', name: 'Hamza Fayaz', timeInSeconds: 56, life: 83),
      Topper(countryCode: 'us', name: 'Fake Justine', timeInSeconds: 56, life: 70),
    ],
    isPast: false,
    isCollapsed: true,
  ),
];

double scrollPosition = 0.0;

class Journey extends StatefulWidget {
  const Journey({
    super.key,
  });

  @override
  State<Journey> createState() => _JourneyState();
}

class _JourneyState extends State<Journey> {
  @override
  void initState() {
    _unlockLevels(); //this method gets the length of levels in the level table and unlocks the levels accordingly in the GenericLevelWidget list

    // get the count of the levels
    super.initState();
    //addingthe scroll listener to the scroll controller
    _scrollController.addListener(() {
      scrollPosition = _scrollController.position.pixels;
      print('Scroll position: $scrollPosition');
    });

    //jumping to scrollposition
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(scrollPosition);
    }
  }

  Future<void> _unlockLevels() async {
    int count = await databaseService!.getLevelCount();

    print('Levels in the table count: $count');
    for (int i = 0; i <= count; i++) {
      if (i < 10) levels[i].isPast = true;
    }
    setState(() {});
  }

  //creating a scroll controller to maintain the scroll position of the listview
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(scrollPosition);
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Scrollbar(
          //show the scroll bar
          thickness: 5.4,
          radius: Radius.circular(10),

          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 25),
                  child: Text(
                    'Worldwide Toppers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              // Timeline widget
              // Container for each level
              // Avatar
              // Name
              // Score

              //use the spread operator on the list of GenericLevelWidget to create the timeline tiles
              ...levels.map((level) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      level.isCollapsed = !level.isCollapsed;
                    });
                  },
                  child: MyTimelineTile(
                    isFirst: level.isFirst,
                    isLast: level.isLast,
                    isPast: level.isPast,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(level.levelName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                'My Position:   ${(level.myPosition < 1000) ? level.myPosition.toString() : '>1000'}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
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

                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (context) => MyApp(
                                              selectedLevel:
                                                  //index of the current element in the list
                                                  levels.indexOf(level) + 1)));
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
                  ),
                );
              }).toList(),
            ],
          ),
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
  String levelName;
  int myPosition;
  List<Topper> toppers;
  bool isPast;
  bool isCollapsed;
  bool isLast;
  bool isFirst;

  GenericLevelWidget({
    this.isFirst = false,
    required this.levelName,
    required this.myPosition,
    required this.toppers,
    required this.isPast,
    required this.isCollapsed,
    this.isLast = false,
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
          backgroundImage: CachedNetworkImageProvider(
            'https://flagcdn.com/w160/$countryCode.jpg',
          ),
        ),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      subtitle: Text('${score} sec'),
      trailing: Icon(Icons.arrow_forward_ios, size: 15),
      onTap: () {
        print('tapped');
      },
    );
  }
}
