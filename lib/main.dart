// ignore_for_file: prefer_const_constructors

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

//this is a base project for the maize app. here we will start off by testing the player moment using the gyroscope sensor.

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            InteractiveViewer(
              maxScale: 3,
              child: GameWidget(game: MyGame()),
            ),
            Align(
              alignment: Alignment.topCenter,
              //for life
              child: Container(
                //add shadow
                //add white outline and black shadow
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),

                height: 10,
                margin: EdgeInsets.fromLTRB(250, 10, 250, 0),
                child: LinearProgressIndicator(
                  //make it rounded cornered add padding and increase hieight
                  backgroundColor: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,

                  value: 0.5,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle FAB press
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
