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

  Future<void> _getDbReady() async {
    _databaseService = DatabaseService();
    await _databaseService!.open();
    User? user = await _databaseService!.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //displaying the PlayerListTile by passing the leader to it. Remember (List<Leader> downloadedLeaders = [] is global)

        ...downloadedLeaders
            .map((leader) => PlayerListTile(
                  leader: leader,
                ))
            .toList(),
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
  String? name;
  String? countryCode;

  @override
  void initState() {
    _getLeaderDetails();
    super.initState();
  }

  Future<void> _getLeaderDetails() async {
    //getting the name and country code of the player from the data_insights collection
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('data_insights').doc(widget.leader.uuid).get();
    final data = snapshot.data();
    if (snapshot.exists) {
      setState(() {
        name = data!['name'];
        countryCode = data['country_code'];
      });
    }
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
          backgroundImage: (countryCode != null) ? NetworkImage('https://flagcdn.com/w160/$countryCode.jpg') : NetworkImage('https://flagcdn.com/w160/pk.jpg'),
        ),
        title: Text(
          name ?? 'Empty Slot',
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
