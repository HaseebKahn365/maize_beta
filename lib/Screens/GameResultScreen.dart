//create a clean game finishing screent that show animated stars using the flutter_animate package and score

/*
the required data for this screen is the timeElapsed, the score and the life
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Firebase_Services/resetter.dart';
import 'package:maize_beta/Screens/Journey.dart';
import 'package:maize_beta/Screens/main_screen.dart';
import 'package:maize_beta/main.dart';
import 'package:maize_beta/my_game.dart';

class GameResultScreen extends StatefulWidget {
  final int timeElapsed;
  final bool isGameOver; //indicates the game was over without completing the level. ie. life became 0
  final int score;
  final int life;
  //hearts, shrinkers, diamonds:
  final int diamonds;
  final int hearts;
  final int shrinkers;
  final int currentLevel;
  const GameResultScreen({
    required this.currentLevel,
    super.key,
    this.isGameOver = true,
    this.diamonds = 0,
    this.hearts = 0,
    this.shrinkers = 0,
    required this.timeElapsed,
    required this.score,
    required this.life,
  });

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

Future<void> createNewHistory(History history) async {
  await databaseService!.createHistory(history);
}

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void initState() {
    print('Attempting to create History');
    createNewHistory(History(diamonds: widget.diamonds, hearts: widget.hearts, shrinkers: widget.shrinkers, level_id: widget.currentLevel, player_id: 1, health: widget.life, score: widget.score, time_elapsed: widget.timeElapsed, date_time: (DateTime.now().millisecondsSinceEpoch)));

    _uploadDataInsights();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.initState();
  }

  Future<void> _uploadDataInsights() async {
    //upload the data insights to the database
    DataInsight allData = await databaseService!.getPlayerStats();
    print('All data for firebase: $allData');

    //upload the data insights to the database
    //check if document exists with current user uuid otherwise create a new document
    if (currentUser == null) {
      currentUser = await databaseService!.getUser();
    }
    Leader me = Leader(uuid: currentUser!.uuid, levels: currentLevelGlobal, collectables: (allData.totalDiamonds + allData.totalHearts + allData.totalShrinkers), score: allData.totalScore);
    checkLeaderAndUpdate(me); //checking if current user has made it in the leaderBoard
    if (FirebaseFirestore.instance.collection('data_insights').doc(currentUser!.uuid).get().then((value) => value.exists) == false) {
      await FirebaseFirestore.instance.collection('data_insights').doc(currentUser!.uuid).set({
        'uuid': currentUser!.uuid,
        'name': currentUser!.name,
        'country_code': currentUser!.country_code,
        'diamonds': 0,
        'hearts': 0,
        'shrinkers': 0,
        'levels_completed': 0,
        'score': 0,
        'time_elapsed': 0,
        'date_time': DateTime.now(),
      });
      return;
    }
    await FirebaseFirestore.instance.collection('data_insights').doc(currentUser!.uuid).set({
      'uuid': currentUser!.uuid,
      'name': currentUser!.name,
      'country_code': currentUser!.country_code,
      'diamonds': allData.totalDiamonds,
      'hearts': allData.totalHearts,
      'levels_completed': allData.totalLevelsCompleted,
      'shrinkers': allData.totalShrinkers,
      'score': allData.totalScore,
      'time_elapsed': allData.totalTimeSpent,
      'date_time': DateTime.now(),
    });

    //Now we checkLeaderAndUpdate by providing a Leader instance made from Me
  }

  @override
  Widget build(BuildContext context) {
    final int hearts = widget.life ~/ 33;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (widget.isGameOver)
                ? Text(
                    'Game Over',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                :
                //Beatiful 'Level Passed' text and aniimated stars
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Level Passed',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < hearts; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 50.0,
                              ).animate(
                                effects: const [
                                  ShakeEffect(
                                      duration: Duration(
                                        seconds: 3,
                                      ),
                                      hz: 5)
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

            Text(
              'Score: ${widget.score}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Time Elapsed: ${widget.timeElapsed}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Life: ${widget.life}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30),
            //a beautiful animated star
            // AnimatedStars(),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
                    //use material page route pushreplacement to go to mainscreen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min, // Use the minimum main axis size
                    mainAxisAlignment: MainAxisAlignment.center, // Center the content in the row
                    children: [
                      Icon(Icons.home), // Add the home icon
                      SizedBox(width: 10), // Add some spacing between the icon and the text
                      Text('Go Back'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
                    //use material page route pushreplacement to go to game screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp(selectedLevel: widget.currentLevel)));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min, // Use the minimum main axis size
                    mainAxisAlignment: MainAxisAlignment.center, // Center the content in the row
                    children: [
                      Icon(Icons.refresh), // Add the home icon
                      SizedBox(width: 10), // Add some spacing between the icon and the text
                      Text('Play Again'),
                    ],
                  ),
                ),
              ],
            ),
            //create a similar button for 'try again'
          ],
        ),
      ),
    );
  }
}
