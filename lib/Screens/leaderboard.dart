// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Firebase_Services/resetter.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

DatabaseService? _databaseService;

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  void initState() {
    _downloadLeaders();

    super.initState();
  }

  Future<void> _downloadLeaders() async {
    //downloading the leaders from the firestore
    downloadLeaders();
    print('leaders: ' + downloadedLeaders.length.toString()); //this will print the number of leaders downloaded from the firestore (10 in this case
    setState(() {
      downloadedLeaders = downloadedLeaders;
    });
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

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  //we need to use the version 4 of RFC4122 UUIDs to generate the uuid

                  final User? user = await _databaseService!.getUser();
                  try {
                    _firestoreServices = FirestoreServices.forUser(user!);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added to firestore')));
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
                  }
                },
                child: Text('Create user in firestore'),
              ),

              //button to create mock levels toppers
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _firestoreServices.createMockLevelToppers();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mock levels toppers created')));
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating mock levels toppers: $e')));
                  }
                },
                child: Text('Create mock levels toppers'),
              ),

              //button to create mock leaderboard toppers
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _firestoreServices.createMockLeaderBoard();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mock leaderboard toppers created')));
                  } catch (e) {
                    //show snakbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating mock leaderboard toppers: $e')));
                  }
                },
                child: Text('Create mock leaderboard toppers'),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

//!just a simple list tile to display the player details

/*
Here is what a Leader instance looks like
 final String uuid;
  final int levels;
  final int collectables;
  final int score;

we are gonna use this to display the player details we just have to pass this instance to the PlayerListTile widget
using it state we will download the name of the player and the country code of the player from the data_insights collection and document under the uuid of the leader

 */

class Temp {
  final String name;
  final String countryCode;

  Temp({
    required this.name,
    required this.countryCode,
  });
}

Map<String, Temp> cachedData = {};

class PlayerListTile extends StatefulWidget {
  final Leader leader;

  const PlayerListTile({
    Key? key,
    required this.leader,
  }) : super(key: key);

  @override
  State<PlayerListTile> createState() => _PlayerListTileState();
}

class _PlayerListTileState extends State<PlayerListTile> {
  @override
  void initState() {
    super.initState();
    _cacheTheUser();
  }

  Future<void> _cacheTheUser() async {
    //checking if the data is already cached
    if (cachedData.containsKey(widget.leader.uuid)) {
      return;
    }

    //if not cached then download the data from the firestore
    final data = await FirebaseFirestore.instance.collection('data_insights').doc(widget.leader.uuid).get();
    final name = data.get('name');
    final countryCode = data.get('country_code');

    //caching the data
    cachedData[widget.leader.uuid] = Temp(name: name, countryCode: countryCode);

    setState(() {
      cachedData = cachedData;
    });
  }

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
          backgroundImage: (cachedData[widget.leader.uuid] != null ? NetworkImage('https://flagcdn.com/w160/${cachedData[widget.leader.uuid]!.countryCode}.jpg') : NetworkImage('https://google.com/w160/pk.jpg')),
        ),
        title: Text(
          cachedData[widget.leader.uuid]?.name ?? 'Empty Slot',
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Current Level:  ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  widget.leader.levels.toString(),
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
                  widget.leader.collectables.toString(),
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
                  widget.leader.score.toString(),
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
