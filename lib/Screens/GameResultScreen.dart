//create a clean game finishing screent that show animated stars using the flutter_animate package and score

/*
the required data for this screen is the timeElapsed, the score and the life
 */

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Screens/main_screen.dart';

class GameResultScreen extends StatefulWidget {
  final int timeElapsed;
  final bool isGameOver; //indicates the game was over without completing the level. ie. life became 0
  final int score;
  final int life;
  //hearts, shrinkers, diamonds
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
    FlameAudio.play('gameover.wav');
    print('Attempting to create History');
    createNewHistory(History(diamonds: widget.diamonds, hearts: widget.hearts, shrinkers: widget.shrinkers, level_id: widget.currentLevel, player_id: 1, health: widget.life, score: widget.score, time_elapsed: widget.timeElapsed, date_time: (DateTime.now().millisecondsSinceEpoch)));

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.initState();
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
            ElevatedButton(
              onPressed: () {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
                //use material page route pushreplacement to go to mainscreen
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
