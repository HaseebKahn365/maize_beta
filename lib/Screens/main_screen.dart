// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flame/flame.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Screens/Journey.dart';
import 'package:maize_beta/Screens/leaderboard.dart';

//creating a global db instance
DatabaseService? databaseService;

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
    Flame.device.setPortrait();
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    //initialize the db
    databaseService = DatabaseService();
    databaseService!.open();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  }

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(
      colorSchemeSeed: colorOptions[colorSelected],
      //override the background color
      scaffoldBackgroundColor: useLightMode ? Color.fromARGB(255, 252, 252, 252) : Color.fromARGB(255, 15, 15, 15), useMaterial3: useMaterial3,
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
      //use flutter_statusbarcolor_ns to set tge color of the status bar to depending on the theme:
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
        //i don't want its color to change when body is scrolled\

        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black12 : Colors.white,

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

      // we are gonna use a bottom sheet to picker the country code and also allow user to set his name
      //using country_code_picker package
      floatingActionButton: (selectedScreen == 1)
          ? SizedBox.shrink()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: (isAccountSet) ? 1 : _animationController.value,
                          child: FloatingActionButton(
                            onPressed: () {
                              String selectedCountry = 'ps';
                              String countryName = 'Palestine';
                              //show the bottom sheet
                              showModalBottomSheet(
                                //take up full screen
                                isScrollControlled: true,
                                elevation: 10,
                                showDragHandle: true,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: ListTile(
                                              leading: Icon(
                                                FluentIcons.person_32_filled,
                                                size: 40,
                                              ),
                                              title: Text(
                                                'Set Account',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              trailing: OutlinedButton(
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                                child: Text('Save'),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'My Name',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          //text box for getting the name from user
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(25.0, 10, 25, 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(15),
                                                hintText: 'Enter your name',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  'My Country',
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                              ),
                                              //list tile show country name and flag
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: ListTile(
                                                  onTap: () {
                                                    //show the country picker
                                                    showCountryPicker(
                                                      context: context,
                                                      showPhoneCode: false,
                                                      onSelect: (Country country) {
                                                        print('Select country: ${country.countryCode.toLowerCase()}');
                                                        setState(() {
                                                          selectedCountry = country.countryCode.toLowerCase();
                                                          countryName = country.name;
                                                        });
                                                      },
                                                      countryListTheme: CountryListThemeData(
                                                        flagSize: 30,
                                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                        textStyle: TextStyle(fontSize: 15),
                                                      ),
                                                    );
                                                  },
                                                  title: Text(
                                                    countryName,
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                  trailing: CircleAvatar(
                                                    //use cached network image dependency instead:
                                                    // NetworkImage('https://flagcdn.com/w160/$selectedCountry.jpg')

                                                    backgroundImage: CachedNetworkImageProvider(
                                                      'https://flagcdn.com/w160/$selectedCountry.jpg',
                                                    ),
                                                    radius: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            child: Icon(FluentIcons.person_20_regular),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
