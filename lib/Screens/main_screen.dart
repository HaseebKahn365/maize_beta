// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flame/flame.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:maize_beta/AdServices/ad_service.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Firebase_Services/resetter.dart';
import 'package:maize_beta/Screens/Journey.dart';
import 'package:maize_beta/Screens/leaderboard.dart';
import 'package:url_launcher/url_launcher.dart';

//creating a global db instance
DatabaseService? databaseService;
User? currentUser;

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
const List<String> colorText = <String>["Purple", "Blue", "Teal", "Green", "Yellow", "Orange", "Pink", "Lime"];

int colorSelected = 0;

bool useLightMode = true;

class _MainScreenState extends State<MainScreen> {
  bool useMaterial3 = true;
  int screenIndex = 0;

  late ThemeData themeData;

  //creating an instance of the ad service

  @override
  initState() {
    Flame.device.setPortrait();
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    //initialize the db

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    //loading the ad
  }

  void setNewColor(int colorIndex) {
    setState(() {
      colorSelected = colorIndex;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
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
        setNewColor: setNewColor,
        useLightMode: useLightMode,
        handleBrightnessChange: handleBrightnessChange,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool useLightMode;
  final VoidCallback handleBrightnessChange;
  //create a callback for setting new color
  final Function(int) setNewColor;

  HomeScreen({
    Key? key,
    required this.setNewColor,
    required this.useLightMode,
    required this.handleBrightnessChange,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AdService adService = AdService();

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedScreen = 0;
  bool isAccountSet = false;

  late AnimationController _animationController;

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  _composeAndSendFeedback(String? feedback) async {
    //here depending on feedback string we are also gonna perform admin actions.. this iis the secrete admin logic:
    /*
    Check if parsing the string gives an integer, if it does, then we are gonna perform admin actions
    actions like: resetting the levels collection in the firestore 
    also resetting the leaderboard collection in firestore
    execution of the admin action depends on wether of not the document exists in the firestore under the collection Admin_Secrets
     */

    //parsing the feedback

    int? parsedFeedback = int.tryParse(feedback!);
    if (feedback == '' || feedback.isEmpty) {
      return;
    }
    if (parsedFeedback != null) {
      //perform admin actions
      //check if the document exists in the firestore under the collection Admin_Secrets
      bool documentExists = await FirebaseFirestore.instance.collection('Admin_Secrets').doc('0314').get().then((value) => value.exists);
      if (documentExists) {
        //perform the admin actions
        switch (parsedFeedback) {
          case 1234:
            //reset the levels collection in the firestore
            print('resetting the levels collection in the firestore');
            //here i am gonna reset the entire levels collection in the firestore becauuse i want the new players to appear as the toppers of each

            try {
              await resetLevels();
              SnackBar(content: Text('Levels collection reset!'));
            } catch (e) {
              SnackBar(content: Text('Error resetting the levels collection!'));
            }

            break;
          case 5678:
            //reset the leaderboard collection in the firestore
            print('resetting the leaderboard collection in the firestore');
            await resetLeaderBoard();
            break;
          default:
            break;
        }
      } else {
        print('admin action denied document does not exist!');
      }
    }

    //send the feedback to the admin: haseebkahn365@outlook.com
    //using the url launcher
    print('Feedback to be sent: $feedback');

    //sending the feedback to the email:
    //launch the email client with the feedback
    //using the url_launcher package

    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'haseebkhan365@outlook.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Feedback for Maiz Game!',
          'body': feedback,
        }));
    launchUrl(_emailLaunchUri);
  }

  @override
  void initState() {
    super.initState();
    databaseService!.open();
    adService.loadBannerAd();

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
      appBar:
          //if the bottom navigation bar selected index is 0 and the ad is loaded the show the ad in the appbar otherwise

          (adService.isBannerAdLoaded && selectedScreen == 0)
              ? PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight + (adService.isBannerAdLoaded && selectedScreen == 0 ? 50.0 : 0.0)), // 50.0 is the height of the ad
                  child: Stack(
                    children: [
                      if (adService.isBannerAdLoaded && selectedScreen == 0)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width, // Set the width to the screen width
                            height: 50.0, // Set the height to the height of the ad
                            child: AdWidget(ad: adService.bannerAd),
                          ),
                        ),
                    ],
                  ),
                )
              : AppBar(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black12 : Colors.white,
                  title: Text('Maiz'),
                  actions: [
                    //an icon button for feedback
                    IconButton(
                      onPressed: () {
                        //show the feedback dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            String feedback = '';
                            return AlertDialog(
                              title: Text('Feedback'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Let me know about your problem or Suggestion!\n'),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Feedback',
                                      border: OutlineInputBorder(),
                                      //make it multilined
                                    ),
                                    onChanged: (value) {
                                      feedback = value;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _composeAndSendFeedback(feedback);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Send'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(FluentIcons.chat_24_regular),
                    ),
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
                            onPressed: () async {
                              currentUser = await databaseService!.getUser();
                              print('Got the user with: ${currentUser!.name}');
                              if (currentUser!.name != 'Anon') {
                                setState(() {
                                  isAccountSet = true;
                                });
                              }

                              String selectedCountry = currentUser!.country_code;
                              //get country name from country_code ie 'pk' implies Pakistan using package: country_picker
                              String countryName = Country.parse(currentUser!.country_code).name;
                              String tempName = currentUser!.name;
                              //show the bottom sheet
                              // ignore: use_build_context_synchronously
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
                                                onPressed: () async {
                                                  await databaseService!.updateProfile(User(
                                                    id: 1,
                                                    uuid: currentUser!.uuid,
                                                    name: tempName,
                                                    country_code: selectedCountry,
                                                  ));
                                                  setState(() {
                                                    //update the user in the database:
                                                    print('update profile complete');
                                                    currentUser = User(
                                                      id: 1,
                                                      uuid: currentUser!.uuid,
                                                      name: tempName,
                                                      country_code: selectedCountry,
                                                    );
                                                  });
                                                  Navigator.pop(context);
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
                                              //temp string = changed string
                                              onChanged: (value) {
                                                tempName = value;
                                              },

                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(15),
                                                hintText: (currentUser!.name),
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

                                              const SizedBox(height: 20),
                                              //create a single child scroll view with horizontal scrolling that allows the user to select the color from the list of colors and update the theme
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(
                                                    colorText.length,
                                                    (index) => Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          widget.setNewColor(index);
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.2),
                                                                blurRadius: 5,
                                                                spreadRadius: 0.3,
                                                              ),
                                                            ],
                                                            color: colorOptions[index],
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              colorText[index],
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              //creating a giant button to reset the account which will simply delete the dattabase and navigate to the main screen
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25),
                                                child: Container(
                                                  width: 200,
                                                  height: 100,
                                                  child: ElevatedButton.icon(
                                                    label: Text('Reset Account'),
                                                    icon: Icon(FluentIcons.delete_24_regular),
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      //reset the account
                                                      //show confirmation dialogue that asks the user too long press the confirm button to delete the account
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text('Reset Account?'),
                                                            content: Text('Are you sure you want to reset your account?\n\nLong Press to confirm the action!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {},
                                                                onLongPress: () async {
                                                                  //reset the account
                                                                  await databaseService!.closeAndDelete();
                                                                  Navigator.pop(context);
                                                                  Future.delayed(Duration(milliseconds: 100), () {
                                                                    //use material route to pushreplacement
                                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                                                  });
                                                                },
                                                                child: Text('Confirm'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
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
                            //make the flag fill the FAButton

                            child: (isAccountSet)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://flagcdn.com/w160/${currentUser!.country_code}.jpg',
                                        placeholder: (context, url) => Icon(FluentIcons.person_20_filled),
                                        errorWidget: (context, url, error) => Icon(FluentIcons.person_20_filled),
                                      ),
                                    ),
                                  )
                                : Icon(FluentIcons.person_20_regular),
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
