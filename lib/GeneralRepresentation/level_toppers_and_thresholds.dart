//class to parse and store level toppers document fro firestore for a specific level

/*
Structure of the level toppers document in firestore
  '1': {
            'uuid': user.uuid,
            'time': 120,
            'life': 100,
            'score': 2310,
          },
          '2': {
            'uuid': '213jo12i3jii-12n',
            'time': 130,
            'life': 90,
            'score': 2300,
          },
          '3': {
            'uuid': '213jo12i3jii-12n',
            'time': 140,
            'life': 80,
            'score': 2290,
          },
          '4': {
            'uuid': '213jo12i3jii-12n',
            'time': 150,
            'life': 70,
            'score': 2280,
          },
          '5': {
            'uuid': '213jo12i3jii-12n',
            'time': 160,
            'life': 60,
            'score': 2270,
          },
          '6': {
            'uuid': '213jo12i3jii-12n',
            'time': 170,
            'life': 50,
            'score': 2260,
          },
          '7': {
            'uuid': '213jo12i3jii-12n',
            'time': 180,
            'life': 40,
            'score': 2250,
          },
          '8': {
            'uuid': '213jo12i3jii-12n',
            'time': 190,
            'life': 90,
            'score': 2240,
          },
          '9': {
            'uuid': '213jo12i3jii-12n',
            'time': 200,
            'life': 80,
            'score': 2230,
          },
          '10': {
            'uuid': '213jo12i3jii-12n',
            'time': 210,
            'life': 70,
            'score': 2220,
          },
          '100': {
            'time': 220,
            'life': 60,
            'score': 2210,
            'total_participants': 100,
          },
          '200': {
            'time': 230,
            'life': 50,
            'score': 2200,
            'total_participants': 100,
          },
          '300': {
            'time': 240,
            'life': 40,
            'score': 2190,
            'total_participants': 100,
          },
          '400': {
            'time': 250,
            'life': 30,
            'score': 2180,
            'total_participants': 100,
          },
          '500': {
            'time': 260,
            'life': 20,
            'score': 2170,
            'total_participants': 100,
          },
          '600': {
            'time': 270,
            'life': 10,
            'score': 2160,
            'total_participants': 100,
          },
          '700': {
            'time': 280,
            'life': 90,
            'score': 2150,
            'total_participants': 100,
          },
          '800': {
            'time': 290,
            'life': 80,
            'score': 2140,
            'total_participants': 100,
          },
          '900': {
            'time': 300,
            'life': 70,
            'score': 2130,
            'total_participants': 100,
          },
          '1000': {
            'time': 310,
            'life': 60,
            'score': 2120,
            'total_participants': 58,
          },
        }
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class LocalObjectForLevel {
  //storing the level toppers data for easy access
  int level = 1;
  final List<LevelTopper?> toppers = [];
  final List<LevelTopperThreshold?> levelThresholds = [];

  //named constructor to download the data from firestore and parse it into LevelTopper and LevelTopperThreshold objects and add them to the respective lists
  Future<LocalObjectForLevel?> downloadLevelToppersAndThresholds(int level) async {
    this.level = level;
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('levels').doc(level.toString()).get();
    final Map<String, dynamic> data = doc.data()!;
    print(data);
    //Here is what the data looks like
    /*{1000: {score: 2120, total_participants: 58, time: 310, life: 60}, 100: {score: 2210, total_participants: 100, time: 220, life: 60}, 1: {score: 2310, time: 120, uuid: bd1ae9fb-d261-4493-9b6b-8f7ee5de2362, life: 100}, 200: {score: 2200, total_participants: 100, time: 230, life: 50}, 
   2: {score: 2300, time: 130, uuid: 213jo12i3jii-12n, life: 90}, 3: {score: 2290, time: 140, uuid: 213jo12i3jii-12n, life: 80}, 300: {score: 2190, total_participants: 100, time: 240, life: 40}, 4: {score: 2280, time: 150, uuid: 213jo12i3jii-12n, life: 70}, 400: {score: 2180, total_participants: 100, time: 250, life: 30}, 500: {score: 2170, total_participants: 100, time: 260, life: 20}, 5: {score: 2270, time: 160, uuid: 213jo12i3jii-12n, life: 60}, 600: {score: 2160, total_participants: 100, time: 270, life: 10}, */

    //parsing the level toppers data
    for (int i = 1; i <= 10; i++) {
      if (data.containsKey(i.toString())) {
        toppers.add(LevelTopper.fromMap(data[i.toString()]));
        print("${LevelTopper.fromMap(data[i.toString()])} added to toppers");
      }
    }

    //parsing the level thresholds data
    for (int i = 100; i <= 1000; i += 100) {
      if (data.containsKey(i.toString())) {
        levelThresholds.add(LevelTopperThreshold.fromMap(data[i.toString()]));
        print("${LevelTopperThreshold.fromMap(data[i.toString()])} added to levelThresholds");
      }
    }

    return this;
  }

  //toString for the entire object
  @override
  String toString() {
    return 'Level: $level, Toppers: $toppers, Thresholds: $levelThresholds';
  }
}

class LevelTopper {
  final String uuid;
  final int time;
  final int life;
  final int score;

  LevelTopper({required this.uuid, required this.time, required this.life, required this.score});

  factory LevelTopper.fromMap(Map<String, dynamic> data) {
    return LevelTopper(
      uuid: data['uuid'],
      time: data['time'],
      life: data['life'],
      score: data['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'time': time,
      'life': life,
      'score': score,
    };
  }

  //toString for the entire object
  @override
  String toString() {
    return '{\n UUID: $uuid, Time: $time, Life: $life, Score: $score\n}';
  }
}

class LevelTopperThreshold {
  final int score;
  final int time;
  final int life;
  final int totalParticipants;

  LevelTopperThreshold({required this.score, required this.time, required this.life, required this.totalParticipants});

  factory LevelTopperThreshold.fromMap(Map<String, dynamic> data) {
    return LevelTopperThreshold(
      score: data['score'],
      time: data['time'],
      life: data['life'],
      totalParticipants: data['total_participants'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'time': time,
      'life': life,
      'total_participants': totalParticipants,
    };
  }

  //toString for the entire object
  @override
  String toString() {
    return '{\n Score: $score, Time: $time, Life: $life, Total Participants: $totalParticipants\n}';
  }
}
