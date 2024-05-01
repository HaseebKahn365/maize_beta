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
  int level = 0; //This class must not be initiated without calling the downloadLevelToppersAndThresholds method
  final List<LevelTopper?> toppers = [];
  final List<LevelTopperThreshold?> levelThresholds = [];

  //constructor
  LocalObjectForLevel();

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
      } else {
        toppers.add(null);
      }
    }

    //parsing the level thresholds data
    for (int i = 100; i <= 1000; i += 100) {
      if (data.containsKey(i.toString())) {
        levelThresholds.add(LevelTopperThreshold.fromMap(data[i.toString()]));
        print("${LevelTopperThreshold.fromMap(data[i.toString()])} added to levelThresholds");
      } else {
        levelThresholds.add(null);
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
  int score;
  int time;
  int life;
  int totalParticipants;

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

//creating a method to upload data to firestore when game is finished for a specific level
/*
Here are the rules for uploading the data to the levels collection. The data may or maynot be uploaded depending on the data from the finished game

#### Definining the structure and rules for the level document: {toppers}
1. The document id will be the level number.
2. if the level document is not present then create it
3. if the level document is present then check if the player is in the top 10 or not. 
4. Start comparing the player with the first row in the document. if the document is empty then add the current player to the top 1.
5. if the document is not empty then compare the player with the first row. if the player is better than the first row then replace the uid of that player with the current player and move the rest of the rows down by one position {this will cause alot of overhead so we will have to just replace that player with uuid of the current player.}
6. if the player is not better than the first row then compare the player with the second row and so on.
7. if the player is not better than any of the top 10 players then check if the player is eligible for the threshold. if the player is eligible for the threshold then increment the count of the participants of that threshold.
8. if the player is not eligible for any of the thresholds then do nothing.

#### Defining the structure and rules for the levels collection: {thresholds}
1. if the player is not in the top 10 then check if the player is eligible for any of the thresholds.
2. if the player is eligible for the threshold then increment the count of the participants of that threshold. this will indicate that the player has position <100 if the player is in the first threshold. if the player is in the second threshold then the player has position <200 and so on.
3. if the player is not eligible for any of the thresholds then do nothing.



 */

//Strategy:
/*
Future<void> TryLevelTopperRefresh(LocalObjectForLevel currentLevel, LevelTopper currentPlayerAndData){
  //the provided objects in the arguments containt the current player and level for the game that just got finished
  now we we start comparing the current player and data with the data in the currentLevel object and update the data accordingly
}

 */

//creating a method to upload data to firestore when game is finished for a specific level

Future<void> TryLevelTopperRefresh(LocalObjectForLevel currentLevel, LevelTopper currentPlayerAndData) async {
  //the provided objects in the arguments containt the current player and level for the game that just got finished
  //now we we start comparing the current player and data with the data in the currentLevel object and update the data accordingly

  //checking if the player is in the top 10 or not
  bool isPlayerInTop10 = false;
  for (int i = 0; i < currentLevel.toppers.length; i++) {
    if (currentLevel.toppers[i] == null) {
      isPlayerInTop10 = true;
      break;
    }
    if (currentLevel.toppers[i]!.score < currentPlayerAndData.score) {
      isPlayerInTop10 = true;
      break;
    }
  }

  //if the player is in the top 10 then update the data
  if (isPlayerInTop10) {
    for (int i = 0; i < currentLevel.toppers.length; i++) {
      if (currentLevel.toppers[i] == null) {
        currentLevel.toppers[i] = currentPlayerAndData;

        break;
      }
      /*
     {least time to complete the level
most % of life remaining
most score

}
criterias for the top 10 players. if time is matched the compare the life and then the score
     
      */
      //if the player is elgible for the top 10 then update the player data by complete knockout. meaning that the player data will be replaced in firestore
      //comparing the time
      if (currentLevel.toppers[i]!.time > currentPlayerAndData.time) {
        LevelTopper temp = currentLevel.toppers[i]!;
        print("Due to better timing $temp is replaced by $currentPlayerAndData");
        //initiate the imdediate upload
        //replace the current player with the player at the current index
        currentLevel.toppers[i] = currentPlayerAndData;
        print(currentLevel.toString() + "is the current level before uplooad");
        print(currentLevel.toppers[i]!.toString() + 'is the newly addeed player');
        await ImmediateUpload(currentLevel);
        throw AbortRefreshingLevel('Data uploaded successfully');
      }
      //comparing the life
      if (currentLevel.toppers[i]!.time == currentPlayerAndData.time) {
        if (currentLevel.toppers[i]!.life < currentPlayerAndData.life) {
          LevelTopper temp = currentLevel.toppers[i]!;
          print("Due to better life $temp is replaced by $currentPlayerAndData");
          currentLevel.toppers[i] = currentPlayerAndData;

          await ImmediateUpload(currentLevel);
          throw AbortRefreshingLevel('Data uploaded successfully');
        }
      }
      //comparing the score
      if (currentLevel.toppers[i]!.time == currentPlayerAndData.time && currentLevel.toppers[i]!.life == currentPlayerAndData.life) {
        if (currentLevel.toppers[i]!.score < currentPlayerAndData.score) {
          LevelTopper temp = currentLevel.toppers[i]!;
          print("Due to better score $temp is replaced by $currentPlayerAndData");
          currentLevel.toppers[i] = currentPlayerAndData;

          await ImmediateUpload(currentLevel);
          throw AbortRefreshingLevel('Data uploaded successfully');
        }
      }
    }
  } else {
    //if the player is not in the top 10 then check if the player is eligible for any of the thresholds
    for (int i = 0; i < currentLevel.levelThresholds.length; i++) {
      if (currentLevel.levelThresholds[i] == null) {
        //create a levelThresholdObject at the current index and upload it to the firestore
        currentLevel.levelThresholds[i] = LevelTopperThreshold(score: currentPlayerAndData.score, time: currentPlayerAndData.time, life: currentPlayerAndData.life, totalParticipants: 1);
        await ImmediateUpload(currentLevel);
        throw AbortRefreshingLevel('Data uploaded successfully');
      }
      if (currentPlayerAndData.score >= currentLevel.levelThresholds[i]!.score) {
        currentLevel.levelThresholds[i]!.totalParticipants++;
        await ImmediateUpload(currentLevel);
        throw AbortRefreshingLevel('Data uploaded successfully');
      }
    }
  }
}

//exception for success
class SuccessfulUpload implements Exception {
  final String message;
  SuccessfulUpload(this.message);
}

//Define and Exception AbortRefreshingLevel

class AbortRefreshingLevel implements Exception {
  final String message;
  AbortRefreshingLevel(this.message);
}

//method for immediate Upload
/*
Immediate Upload takes a modified LocalObjectForLevel object and uploads it to the firestore

 */

Future<void> ImmediateUpload(LocalObjectForLevel currentLevel) async {
  //upload the data to the firestore
  print('Trying to upload the data to the firestore immediately');

  print(currentLevel.toString());

  try {
    await FirebaseFirestore.instance.collection('levels').doc(currentLevel.level.toString()).set({
      '1': currentLevel.toppers[0]!.toMap(),
      '2': currentLevel.toppers[1]!.toMap(),
      '3': currentLevel.toppers[2]!.toMap(),
      '4': currentLevel.toppers[3]!.toMap(),
      '5': currentLevel.toppers[4]!.toMap(),
      '6': currentLevel.toppers[5]!.toMap(),
      '7': currentLevel.toppers[6]!.toMap(),
      '8': currentLevel.toppers[7]!.toMap(),
      '9': currentLevel.toppers[8]!.toMap(),
      '10': currentLevel.toppers[9]!.toMap(),
      '100': currentLevel.levelThresholds[0]!.toMap(),
      '200': currentLevel.levelThresholds[1]!.toMap(),
      '300': currentLevel.levelThresholds[2]!.toMap(),
      '400': currentLevel.levelThresholds[3]!.toMap(),
      '500': currentLevel.levelThresholds[4]!.toMap(),
      '600': currentLevel.levelThresholds[5]!.toMap(),
      '700': currentLevel.levelThresholds[6]!.toMap(),
      '800': currentLevel.levelThresholds[7]!.toMap(),
      '900': currentLevel.levelThresholds[8]!.toMap(),
      '1000': currentLevel.levelThresholds[9]!.toMap(),
    });
    throw SuccessfulUpload('Data uploaded successfully');
  } catch (e) {
    throw e;
  }
}
