// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:maize_beta/Screens/main_screen.dart';
import 'package:maize_beta/TimelineComponents/mytimeline_tile.dart';
import 'package:maize_beta/main.dart';

List<GenericLevelWidget> levels = [
  GenericLevelWidget(
    levelName: 'Level 1',
    isFirst: true,
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: true,
    isCollapsed: false,
  ),
  GenericLevelWidget(
    levelName: 'Level 2',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: true,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 3',
    myPosition: 1024,
    toppers: [
      //randomized toppers
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 4',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 5',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 6',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 7',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 8',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 9',
    myPosition: 1024,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
    ],
    isPast: false,
    isCollapsed: true,
  ),
  GenericLevelWidget(
    levelName: 'Level 10',
    myPosition: 1024,
    isLast: true,
    toppers: [
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
      Topper(
        collectables: 3,
        score: 100,
        timeInSeconds: 1,
        life: 100,
      ),
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

int currentLevelGlobal = 0;

class _JourneyState extends State<Journey> {
  @override
  void initState() {
    _unlockLevels(); //this method gets the length of levels in the level table and unlocks the levels accordingly in the GenericLevelWidget list
    _updateTheToppers(); //this method updates the toppers in the GenericLevelWidget list by using getTopHistory3() defined in the databseService
    // get the count of the levels
    super.initState();
    //addingthe scroll listener to the scroll controller
    _scrollController.addListener(() {
      scrollPosition = _scrollController.position.pixels;
    });

    //jumping to scrollposition
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(scrollPosition);
    }
  }

  Future<void> _unlockLevels() async {
    int count = await databaseService!.getLevelCount();
    currentLevelGlobal = count;

    print('Levels in the table count: $count');
    for (int i = 0; i <= count; i++) {
      if (i < 10) levels[i].isPast = true;
    }
    setState(() {});
  }

  Future<void> _updateTheToppers() async {
    for (int i = 0; i < levels.length; i++) {
      final toppers = await databaseService!.getTopHistory3(i + 1);
      levels[i].toppers = toppers;
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
                    'Current Level: $currentLevelGlobal',
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
                            //create a Tight outline button that says : Top Records
                            TextButton(
                              onPressed: () {
                                ///expands the list of toppers
                                setState(() {
                                  level.isCollapsed = !level.isCollapsed;
                                });
                              },
                              child: Text(
                                'Recent Records',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        if (!level.isCollapsed)
                          ...level.toppers.map((topper) {
                            return BeautifulEventCard(
                              topper: topper,
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
                        //add a text button to say more levels coming soon if index [9] isPast
                        if (level.isLast && level.isPast)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'More levels coming soon! \n      Stay on TOP 😉🚀',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
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
  final int score;
  final int timeInSeconds;
  final int collectables;
  final int life;

  Topper({
    this.score = 0,
    this.timeInSeconds = 0,
    this.collectables = 0,
    this.life = 0,
  });
}

class BeautifulEventCard extends StatelessWidget {
  final Topper topper;
  const BeautifulEventCard({
    super.key,
    required this.topper,
  });

  //Structure of the listile:
  /*
  the circle avatar will display the timeInSeconds.toString + 's'
  the title text will be life.toString() + '❤️'
  the subtitle will be the score.toString()
  the trailing will be collectables.toString() + '🔥'

   */

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
          maxRadius: 30,
          child: Text('${topper.timeInSeconds}s'),
        ),
      ),
      title: Text(
        '${topper.life} ❤️',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        '${topper.score}',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
        ),
      ),
      trailing: Text('${topper.collectables} 🔥', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
      onTap: () {
        print('tapped');
      },
    );
  }
}
