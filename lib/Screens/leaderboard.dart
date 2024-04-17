// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Firebase_Services/firestore_services.dart';
import 'package:uuid/uuid.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

DatabaseService? _databaseService;
late FirestoreServices _firestoreServices;

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  void initState() {
    _getDbReady();

    super.initState();
  }

  Future<void> _getDbReady() async {
    _databaseService = DatabaseService();
    await _databaseService!.open();
    _firestoreServices = FirestoreServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //here we will display the top 100 player and their following details. these player will be sorted based oon the following criteria

        /*
          1. most levels completed
          2. most collectables collected
          3. least damage taken
          
           */

        //each player will have the following details
        //1. avatar as country flag
        //2. name

        //3. levels completed
        //4. collectables collected
        //5. damage taken

        //6. total score

        PlayerListTile(
          name: 'Abdul Haseeb',
          countryCode: 'pk',
          levelsCompleted: 10,
          collectablesCollected: 100,
          damageTaken: 100,
          totalScore: 1000,
        ),

        PlayerListTile(
          name: 'Abdul Haseeb',
          countryCode: 'pk',
          levelsCompleted: 10,
          collectablesCollected: 100,
          damageTaken: 100,
          totalScore: 1000,
        ),

        //creating buttons to test the db services

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  //we need to use the version 4 of RFC4122 UUIDs to generate the uuid
                  final String uuid = const Uuid().v4();
                  final User user = User(id: 1, name: 'Abdul Haseeb', country_code: 'pk', uuid: uuid);
                  try {
                    await _databaseService!.updateProfile(user);
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
                  }
                },
                child: Text('Create Profile'),
              ),

              //get the user
              ElevatedButton(
                onPressed: () async {
                  try {
                    final User? myUser = await _databaseService!.getUser();
                    print('myUser: $myUser');
                    if (myUser != null) {
                      //show snakbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('myUser: $myUser')));
                    }
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting myUser: $e')));
                  }
                },
                child: Text('Get User'),
              ),

              //Testing the level table
              ElevatedButton(
                onPressed: () async {
                  final Level level = Level(id: 1, name: "Desert");
                  final Level level2 = Level(id: 2, name: "Forest");
                  try {
                    await _databaseService!.createLevel(level);
                    await _databaseService!.createLevel(level2);
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating level: $e')));
                  }
                },
                child: Text('Create Level'),
              ),

              //get the level
              ElevatedButton(
                onPressed: () async {
                  try {
                    final List<Level?> myLevels = await _databaseService!.getLevels();
                    print('myLevel: $myLevels');
                    if (myLevels != null) {
                      //show snakbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('myLevel: ${myLevels.length}')));
                    }
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting myLevel: $e')));
                  }
                },
                child: Text('Get Level'),
              ),

              //Testing the History table

              ElevatedButton(
                onPressed: () async {
                  final History history = History(
                    //id for history is not needed as it is auto incremented
                    level_id: 1,
                    diamonds: 10,
                    health: 100,
                    //int date time since epoch in milliseconds
                    date_time: DateTime.now().millisecondsSinceEpoch,
                    hearts: 5,
                    player_id: 1,
                    shrinkers: 2,
                    //time in seconds
                    time_elapsed: 21,
                    score: 1000,
                  );

                  try {
                    await _databaseService!.createHistory(history);
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating history: $e')));
                  }
                },
                child: Text('Create History'),
              ),

              //get the history
              ElevatedButton(
                onPressed: () async {
                  try {
                    final List<History?> myHistory = await _databaseService!.getHistory();
                    print('myHistory: $myHistory');
                    if (myHistory != null) {
                      //show snakbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('myHistory: ${myHistory.length}')));
                    }
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting myHistory: $e')));
                  }
                },
                child: Text('Get History'),
              ),

              //deleting the entire db
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _databaseService!.closeAndDelete();
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting db: $e')));
                  }
                },
                child: Text('Delete DB'),
              ),
            ],
          ),
        ),

        //creating buttons to test the firebase firestore services

        ElevatedButton(
          onPressed: () async {
            //we need to use the version 4 of RFC4122 UUIDs to generate the uuid

            final User? user = await _databaseService!.getUser();
            try {
              await _firestoreServices.addUser(user!);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added to firestore')));
            } catch (e) {
              //show snakbar
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
            }
          },
          child: Text('Create user in firestore'),
        ),
      ],
    ));
  }
}

//!just a simple list tile to display the player details

class PlayerListTile extends StatelessWidget {
  final String name;
  final String countryCode;
  final int levelsCompleted;
  final int collectablesCollected;
  final int damageTaken;
  final int totalScore;
  const PlayerListTile({
    super.key,
    required this.name,
    required this.countryCode,
    required this.levelsCompleted,
    required this.collectablesCollected,
    required this.damageTaken,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage('https://flagcdn.com/w160/$countryCode.jpg'),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Levels Completed:  ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  levelsCompleted.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Collectables Collected:  ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  collectablesCollected.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Damage Taken:  ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  damageTaken.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Total Score:  ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  totalScore.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
