//create a clean game finishing screent that show animated stars using the flutter_animate package and score

/*
the required data for this screen is the timeElapsed, the score and the life
 */

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maize_beta/Screens/main_screen.dart';

class GameResultScreen extends StatefulWidget {
  final int timeElapsed;
  final int score;
  final int life;
  const GameResultScreen({
    super.key,
    required this.timeElapsed,
    required this.score,
    required this.life,
  });

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void initState() {
    FlameAudio.play('gameover.wav');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
