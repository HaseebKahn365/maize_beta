// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

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
    User? user = await _databaseService!.getUser();
    _firestoreServices = FirestoreServices.forUser(
      user!,
    );
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
          name: 'Tayyab Ahmad',
          countryCode: 'ps',
          levelsCompleted: 10,
          totalScore: 382314,
          collectablesCollected: 2323,
          damageTaken: 100,
        ),

        PlayerListTile(
          name: 'Abdul Haseeb',
          countryCode: 'ps',
          levelsCompleted: 10,
          collectablesCollected: 2341,
          damageTaken: 142,
          totalScore: 412435,
        ),

        PlayerListTile(
          name: 'Muhammad Bilal',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
          damageTaken: Random().nextInt(200),
        ),

        PlayerListTile(
          name: 'Muhammad Hammad',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
          damageTaken: Random().nextInt(200),
        ),

        PlayerListTile(
          name: 'Kanetkar Saab',
          countryCode: 'in',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
          damageTaken: Random().nextInt(200),
        ),

        PlayerListTile(
          name: 'Hamza Fayaz',
          countryCode: 'pk',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
          damageTaken: Random().nextInt(200),
        ),

        PlayerListTile(
          name: 'Temmethy Jr.',
          countryCode: 'au',
          levelsCompleted: 10,
          totalScore: Random().nextInt(500000),
          collectablesCollected: Random().nextInt(3000),
          damageTaken: Random().nextInt(200),
        ),

        //creating buttons to test the db services

        //creating buttons to test the firebase firestore services
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
