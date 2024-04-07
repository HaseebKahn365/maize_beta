import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/my_game.dart';

//this is a base project for the maize app. here we will start off by testing the player moment using the gyroscope sensor.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  // final myGame = MyGame();
  runApp(
    InteractiveViewer(
      maxScale: 3,
      child: GameWidget(game: MyGame()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maize Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the flame screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameWidget(
                        game: MyGame(),
                      )),
            );
          },
          child: const Text('Click me!'),
        ),
      ),
    );
  }
}
