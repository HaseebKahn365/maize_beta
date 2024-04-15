import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maize_beta/Screens/Journey.dart';
import 'package:maize_beta/Screens/leaderboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const double narrowScreenWidthThreshold = 450;

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [
  m3BaseColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.lime,
  Colors.red,
  Colors.purple,
  Colors.brown,
  Colors.cyan,
  Colors.indigo,
  Colors.amber,
];
const List<String> colorText = <String>["M3 Baseline", "Blue", "Teal", "Green", "Yellow", "Orange", "Pink", "Lime"];

class _MainScreenState extends State<MainScreen> {
  bool useMaterial3 = true;
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = 0;

  late ThemeData themeData;

  @override
  initState() {
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
  }

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(
      colorSchemeSeed: colorOptions[colorSelected],
      //override the background color
      scaffoldBackgroundColor: useLightMode ? Colors.white : Colors.black,
      useMaterial3: useMaterial3,
      brightness: useLightMode ? Brightness.light : Brightness.dark,
    );
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void handleBrightnessChange() {
    setState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = value;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maize Beta',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      home: HomeScreen(
        useLightMode: useLightMode,
        handleBrightnessChange: handleBrightnessChange,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool useLightMode;
  final VoidCallback handleBrightnessChange;

  HomeScreen({
    Key? key,
    required this.useLightMode,
    required this.handleBrightnessChange,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedScreen = 0;
  bool isAccountSet = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..repeat(reverse: true, min: 0.8);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maize Beta'),
        actions: [
          IconButton(
            onPressed: () {
              //handle the brightness change
              widget.handleBrightnessChange();
            },
            icon: Icon(widget.useLightMode ? FluentIcons.weather_sunny_24_regular : FluentIcons.weather_moon_24_regular),
          ),
        ],
      ),
      //create a floating action button on the top right corner for profile
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 185.0),
        child: Align(
          alignment: Alignment.topRight,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: (isAccountSet) ? 1 : _animationController.value,
                child: FloatingActionButton(
                  onPressed: () {
                    //handle the account set
                    setState(() {
                      isAccountSet = !isAccountSet;
                    });
                  },
                  child: Icon(FluentIcons.person_20_regular),
                ),
              );
            },
          ),
        ),
      ),

      body: (selectedScreen == 1) ? LeaderBoardScreen() : Journey(),

      //add a bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.home_20_regular),
            label: 'Journey',
            activeIcon: Icon(FluentIcons.home_20_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.top_speed_20_regular),
            label: 'Leaderboard',
            activeIcon: Icon(FluentIcons.top_speed_20_filled),
          ),
        ],
        currentIndex: selectedScreen,
        elevation: 10,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (int index) {
          //handle the screen change
          setState(() {
            selectedScreen = index;
          });
        },
      ),
    );
  }
}
