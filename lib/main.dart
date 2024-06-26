// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maize_beta/Screens/main_screen.dart';
import 'package:maize_beta/firebase_options.dart';
import 'package:maize_beta/my_game.dart';

//now we are gonna start to worrk on the main interface of the entire game app:
/*
MainScreen:
This is the main widget where we are gonna be landing. it will have a floating action button on the top right corner
This FAB will be used by the user for profile settings

in the body we might load the JourneyScreen or LeaderBoardScreen depending on the selection from the BottomNavigationBar

 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainScreen());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final game = MyGame();
    //timer for the game
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (game.showStartOverlay.value == false) {
        game.incrementTimer();
        if (game.som.player.originalPlayerRadius > game.som.player.playerRadius) {
          game.som.player.playerRadius += 0.35;
        }
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            InteractiveViewer(
              //on single tap doown i should do the same

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
            ValueListenableBuilder(
                valueListenable: game.showStartOverlay,
                builder: (BuildContext context, bool value, Widget? child) {
                  return (value)
                      ? GestureDetector(
                          onTap: () {
                            game.startGame();
                          },
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Maize',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Tap to start',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //tap.png from assets/images

                                  Transform.rotate(
                                    angle: -30 * pi / 180,
                                    child: Icon(
                                      FluentIcons.tap_single_32_regular,
                                      color: Colors.white,
                                      size: 70,
                                    ), // replace with your icon
                                  )
                                ],
                              ).animate(
                                effects: [
                                  ScaleEffect(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  )
                                ],
                              ),
                            ),
                            //add blur
                          ))
                      : SizedBox.shrink();
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  SizedBox(height: 20), // Add some spacing between the buttons
                  FloatingActionButton(
                    onPressed: () {
                      final playerAccess = game.som.player;

                      playerAccess.recenterThePlayer();
                      playerAccess.showGuideArc = !playerAccess.showGuideArc;
                      game.showPausedOverlay.value = !game.showPausedOverlay.value;
                    },
                    child: ValueListenableBuilder(
                        valueListenable: game.showPausedOverlay,
                        builder: (BuildContext context, bool value, Widget? child) {
                          return Icon(value ? Icons.pause : Icons.play_arrow);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),

        //add another FAB for pausing the game
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
