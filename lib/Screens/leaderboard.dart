// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maize_beta/Database_Services/db.dart';
import 'package:maize_beta/Firebase_Services/firestore_services.dart';
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
    _getDbReady();

    super.initState();
  }

  Future<void> _getDbReady() async {
    _databaseService = DatabaseService();
    await _databaseService!.open();
    User? user = await _databaseService!.getUser();
  }

  Future<void> _downloadLeaders() async {
    try {
      await downloadLeaders();
      /*
      Here is what the Leader object looks like:
     
        final String uuid;
        final int levels;
        final int collectables;
        final int score;

        we are gonna use the uuid of the player to get the player's name and country code from the database

        then we will start filling in the details for the player list tile. in case if uuid is '' then we will just display 'Empty slot'

      
       */
      for (int i = 0; i < 10; i++) {
        if (downloadedLeaders[i].uuid == '') {
          playersOfLeaderBoardList.add(PlayerOfLeaderBoard(
            name: 'Empty Slot',
            countryCode: '',
            collectables: 0,
            levels: 0,
            score: 0,
          ));
        } else {
          //find the player by uuid in the data_insights collection and get the name and country code. (in data_insights the player's document is under the uuid of the player.)
          PlayerOfLeaderBoard player = await FirebaseFirestore.instance.collection('data_insights').doc(downloadedLeaders[i].uuid).get().then((value) {
            return PlayerOfLeaderBoard(
              name: value.data()!['name'],
              countryCode: value.data()!['country_code'],
              collectables: downloadedLeaders[i].collectables,
              levels: downloadedLeaders[i].levels,
              score: downloadedLeaders[i].score,
            );
          });
        }
      }
    } catch (e) {
      print('Error downloading leaders from leaderBoard screen:  $e');
    }

    setState(() {
      print('finished downloading the leaders');
      playersOfLeaderBoardList = playersOfLeaderBoardList;
    });
  }

  List<PlayerOfLeaderBoard> playersOfLeaderBoardList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        PlayerListTile(
          name: 'Tayyab Ahmad',
          countryCode: 'ps',
          levelsCompleted: 10,
          totalScore: 382314,
          collectablesCollected: 2323,
        ),

        PlayerListTile(
          name: 'Abdul Haseeb',
          countryCode: 'ps',
          levelsCompleted: 10,
          collectablesCollected: 2341,
          totalScore: 412435,
        ),

        PlayerListTile(
          name: 'Muhammad Bilal',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
        ),

        PlayerListTile(
          name: 'Muhammad Hammad',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
        ),

        PlayerListTile(
          name: 'Kanetkar Saab',
          countryCode: 'in',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
        ),

        PlayerListTile(
          name: 'Hamza Fayaz',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
        ),

        PlayerListTile(
          name: 'Temmethy Jr.',
          countryCode: 'au',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
        ),

        //creating buttons to test the db services

        //creating buttons to test the firebase firestore services
      ],
    ));
  }
}

//!just a simple class for details of the PlayerList Tile
class PlayerOfLeaderBoard {
  final String name;
  final String countryCode;
  final int levels;
  final int collectables;
  final int score;

  PlayerOfLeaderBoard({
    required this.name,
    required this.countryCode,
    required this.levels,
    required this.collectables,
    required this.score,
  });
}

//!just a simple list tile to display the player details

class PlayerListTile extends StatelessWidget {
  final String name;
  final String countryCode;
  final int levelsCompleted;
  final int collectablesCollected;
  final int totalScore;
  const PlayerListTile({
    super.key,
    required this.name,
    required this.countryCode,
    required this.levelsCompleted,
    required this.collectablesCollected,
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
                const Text(
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
