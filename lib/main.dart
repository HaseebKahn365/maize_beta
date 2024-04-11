// ignore_for_file: prefer_const_constructors

import 'dart:async';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    final game = MyGame();
    Timer.periodic(Duration(seconds: 1), (timer) {
      game.incrementTimer();
    });
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
                }),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  TextComponent(
                    text: 'Time',
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: game.timeElapsed,
                        builder: (BuildContext context, int value, Widget? child) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              (value < 60) ? '${value} s' : '${value ~/ 60}m ${value % 60}s',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                  ),

                  //add a similar container for keeping track of score
                  TextComponent(
                    text: '\nScore',
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 10, 0),
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: game.score,
                        builder: (BuildContext context, int value, Widget? child) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '$value',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // game.som.player.recenterThePlayer();
            //restart the game
            setState(() {
              game.onLoad();
              //add another FAB on the top right corner keeping track of the time elapsed
            });
          },
          child: Icon(Icons.restart_alt_rounded),
        ),
      ),
    );
  }
}

class TextComponent extends StatelessWidget {
  final String text;
  const TextComponent({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
