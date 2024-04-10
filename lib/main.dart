// ignore_for_file: prefer_const_constructors

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

//this is a base project for the maize app. here we will start off by testing the player moment using the gyroscope sensor.

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    final game = MyGame();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            InteractiveViewer(
              onInteractionUpdate: (details) {
                game.som.player.recenterThePlayer();
                game.som.player.showGuideArc = false;
              },
              onInteractionEnd: (details) {
                game.som.player.showGuideArc = true;
              },
              maxScale: 3,
              child: GameWidget(game: game),
            ),
            Align(
              alignment: Alignment.topCenter,
              //for life
              child: Container(
                //add shadow
                //add white outline and black shadow
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),

                height: 20,
                margin: EdgeInsets.fromLTRB(250, 10, 250, 0),
                // child: LinearProgressIndicator(
                //   //make it rounded cornered add padding and increase hieight
                //   backgroundColor: Colors.grey,
                //   borderRadius: BorderRadius.circular(10),
                //   color: Colors.red,

                //   value: ((game.life.value / 100) > 1) ? 1 : game.life.value / 100,
                // ),

                child: ValueListenableBuilder(
                    valueListenable: game.life,
                    builder: (BuildContext context, int value, Widget? child) {
                      return LinearProgressIndicator(
                        //make it rounded cornered add padding and increase hieight
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                        //increase the value smoothly

                        value: ((value / 100) > 1) ? 1 : value / 100,
                      );
                    }),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: game.life,
                builder: (BuildContext context, int value, Widget? child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(250, 10, 250, 0),
                      child: Text(
                        '$value%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // game.som.player.recenterThePlayer();
            //restart the game
            setState(() {
              game.onLoad();
            });
          },
          child: Icon(Icons.restart_alt_rounded),
        ),
      ),
    );
  }
}
