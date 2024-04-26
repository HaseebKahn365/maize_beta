//Here we are going to use the sqflite package to create and manage the db.
// ignore_for_file: avoid_print, body_might_complete_normally_nullable

/*
Here is what the structure of the db tables look like:

CREATE TABLE `Profile_t` (
  //i forgot to add the uuid column in the Profile_t table
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`name`	INTEGER NOT NULL DEFAULT 'Anon',
	`country_code`	TEXT DEFAULT 'ps'
  `uuid`	TEXT NOT NULL UNIQUE
);


CREATE TABLE `Level_t` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`name`	INTEGER NOT NULL
);


CREATE TABLE `History_t` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`diamonds`	INTEGER NOT NULL DEFAULT 0,
	`hearts`	INTEGER NOT NULL DEFAULT 0,
	`shrinkers`	INTEGER NOT NULL DEFAULT 0,
	`level_id`	INTEGER NOT NULL,
	`player_id`	INTEGER NOT NULL,
	`health`	INTEGER NOT NULL DEFAULT 0,
	`score`	INTEGER NOT NULL DEFAULT 0,
	`time_elapsed`	INTEGER NOT NULL DEFAULT 0,
	`date_time`	INTEGER NOT NULL,
	FOREIGN KEY(`player_id`) REFERENCES `Profile_t`(`id`),
	FOREIGN KEY(`level_id`) REFERENCES `Level_t`(`id`)
);

 */

//Here will be the services for the db
import 'dart:math';

import 'package:maize_beta/Screens/Journey.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  Database? _db;

  Future<void> open() async {
    if (_db != null) {
      throw 'Database already open';
    }
    print('trying to open db');
    try {
      final dbPath = await getApplicationDocumentsDirectory();
      final path = dbPath.path + dbName;
      _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $profileTable (
          $idColumn INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          $nameColumn TEXT NOT NULL DEFAULT 'Anon',
          $countryCodeColumn TEXT DEFAULT 'ps',
          $uuidColumn TEXT NOT NULL UNIQUE
        );
        ''');

        print('created profile table successfully!');

        await db.execute('''
        CREATE TABLE $levelTable (
          $idColumn INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          $nameColumn TEXT NOT NULL
        );
        ''');

        print('created level table successfully!');

        await db.execute('''
        CREATE TABLE $historyTable (
          $idColumn INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          $diamondsColumn INTEGER NOT NULL DEFAULT 0,
          $heartsColumn INTEGER NOT NULL DEFAULT 0,
          $shrinkersColumn INTEGER NOT NULL DEFAULT 0,
          $levelIdColumn INTEGER NOT NULL,
          $playerColumn INTEGER NOT NULL,
          $healthColumn INTEGER NOT NULL DEFAULT 0,
          $scoreColumn INTEGER NOT NULL DEFAULT 0,
          $timeElapsedColumn INTEGER NOT NULL DEFAULT 0,
          $dateTimeColumn INTEGER NOT NULL,
          FOREIGN KEY($playerColumn) REFERENCES $profileTable($idColumn),
          FOREIGN KEY($levelIdColumn) REFERENCES $levelTable($idColumn)
        );
        ''');

        print('created history table successfully!');
      });
    } catch (e) {
      print('Error opening db: $e');
    }
  }

//closing the database
  Future<void> closeAndDelete() async {
    if (_db == null) {
      throw 'Database already closed';
    }
    await _db!.close();
    _db = null;
    final dbPath = await getApplicationDocumentsDirectory();
    final path = dbPath.path + dbName;
    await deleteDatabase(path);
    print('Database deleted successfully!');
  }

  //private function to get the db getDBorThrow

  Future<Database> getDBorThrow() async {
    if (_db == null) {
      throw 'Database not open';
    }
    return _db!;
  }

//!methods for the profile

//only update method for the profile
  Future<void> updateProfile(User user) async {
    final db = await getDBorThrow();
    try {
      //print the count of the rows in the profile table
      final count = await Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $profileTable'));
      if (count != 1) {
        //create a users
        await db.insert(profileTable, user.toMap());
        print('created user successfully!');
      } else {
        print('Trying to update user...');
        await db.update(profileTable, user.toMap(), where: '$idColumn = ?', whereArgs: [user.id]);
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

//method for getting the user
  Future<User?> getUser({int id = 1}) async {
    final db = await getDBorThrow();
    try {
      //read the all the rows using the * operator
      final maps = await db.query(profileTable, where: '$idColumn = ?', whereArgs: [id]);

      if (maps.isNotEmpty) {
        return User.fromRow(maps.first);
      } else {
        //insert the user with name  = Anon and id = uuidV4
        var uuid = Uuid();
        User anonUser = User(id: 1, name: 'Anon', country_code: 'ps', uuid: uuid.v4());
        await db.insert(profileTable, anonUser.toMap());
        return anonUser;
      }
    } catch (e) {
      print('Error getting user: $e');
    }
  }

//!methods for the level

//method for creating a level in the level table
  Future<void> createLevel(Level level) async {
    final db = await getDBorThrow();
    try {
      //check if there are any levels with same id
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $levelTable WHERE $idColumn = ${level.id}'));
      if (count != 0) {
        print('Level with id ${level.id} already exists');
        return;
      }
      await db.insert(levelTable, level.toMap());
    } catch (e) {
      print('Error creating level: $e');
    }
  }

  //method for getting the count of all the levels. we will unlock the levels from this count
  Future<int> getLevelCount() async {
    //perform and advanced querry on history.find the max level_id for which life!=0 . this will be the latest level return it
    final db = await getDBorThrow();

    try {
      List<Map<String, dynamic>> result = await db.query(
        '$historyTable',
        where: 'health != ?',
        whereArgs: [0],
        orderBy: 'level_id DESC',
        limit: 1,
      );

      if (result.isNotEmpty) {
        return result.first['level_id'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error performing query: $e');
      return 0;
    }
  }

//!methods for the history

//Finding three Toppers in the history for a given level
/*
Here are the rules:
for a provided level_id if there are no three instances or less than that then create  instances of Topper()
if there are more than three instances then return the top three instances

 */
  Future<List<Topper>> getTopHistory3(int level_id) async {
    List<Topper> toppers = [Topper(), Topper(), Topper()];

    final db = await getDBorThrow();
    try {
      final maps = await db.query(historyTable, where: 'level_id = ?', whereArgs: [level_id], orderBy: '$dateTimeColumn DESC');
      int count = min(maps.length, toppers.length); // Use the smaller of the two lengths
      for (int i = 0; i < count; i++) {
        toppers[i] = Topper(
          collectables: ((maps[i][diamondsColumn] as int) + (maps[i][heartsColumn] as int) + (maps[i][shrinkersColumn] as int)),
          life: maps[i][healthColumn] as int,
          score: maps[i][scoreColumn] as int,
          timeInSeconds: maps[i][timeElapsedColumn] as int,
        );
        print('Printing topper from history: ${toppers[i]}');
        print('score: ${maps[i][scoreColumn]}');

        print('diamonds: ${maps[i][diamondsColumn]}');
        print('hearts: ${maps[i][heartsColumn]}');
        print('shrinkers: ${maps[i][shrinkersColumn]}');
        int collectables = ((maps[i][diamondsColumn] as int) + (maps[i][heartsColumn] as int) + (maps[i][shrinkersColumn] as int));
        print('collectables: $collectables');
      }
    } catch (e) {
      print('Error getting top history: $e');
    }
    return toppers;
  }

//method for creating a history in the history table
  Future<void> createHistory(History history) async {
    final db = await getDBorThrow();
    try {
      await db.insert(historyTable, history.toMap());
      final historyCount = await getHistoryCount();
      print('Total Histories: $historyCount');
    } catch (e) {
      print('Error creating history: $e');
    }
  }

  //method for getting the count of all the history
  Future<int> getHistoryCount() async {
    final db = await getDBorThrow();
    try {
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $historyTable'));
      return count!;
    } catch (e) {
      print('Error getting history count: $e');
    }
    return 0;
  }

  //method for getting all the history
  Future<List<History>> getHistory() async {
    final db = await getDBorThrow();
    try {
      final maps = await db.query(historyTable);
      return List.generate(maps.length, (index) => History.fromRow(maps[index]));
    } catch (e) {
      print('Error getting history: $e');
    }
    return [];
  }

  //method for getting the all stats of the player.
  /*
  it includes the total time player, total score, total diamonds collected, total shrinkers collected, total hearts collected, total levels completed
   */

  Future<DataInsight> getPlayerStats() async {
    print('Fetching all the player stats from the history table');
    final db = await getDBorThrow();
    try {
      final maps = await db.query(historyTable);
      int totalScore = 0;
      int totalTimeSpent = 0;
      int totalDiamonds = 0;
      int totalShrinkers = 0;
      int totalHearts = 0;
      int totalLevelsCompleted = 0;

      for (var map in maps) {
        totalTimeSpent += map[timeElapsedColumn] as int;
        totalScore += map[scoreColumn] as int;
        totalDiamonds += map[diamondsColumn] as int;
        totalShrinkers += map[shrinkersColumn] as int;
        totalHearts += map[heartsColumn] as int;
        if (map[healthColumn] != 0) {
          totalLevelsCompleted += 1;
        }
      }

      print('Total Time Spent: $totalTimeSpent');
      print('Total Score: $totalScore');
      print('Total Diamonds: $totalDiamonds');
      print('Total Shrinkers: $totalShrinkers');
      print('Total Hearts: $totalHearts');
      print('Total Levels Completed: $totalLevelsCompleted');

      return DataInsight(totalTimeSpent: totalTimeSpent, playerUUID: 1, totalScore: totalScore, totalDiamonds: totalDiamonds, totalShrinkers: totalShrinkers, totalHearts: totalHearts, totalLevelsCompleted: totalLevelsCompleted);
    } catch (e) {
      print('Error getting player stats: $e');
    }
    return DataInsight(totalTimeSpent: 0, playerUUID: 1, totalScore: 0, totalDiamonds: 0, totalShrinkers: 0, totalHearts: 0, totalLevelsCompleted: 0);
  }
}

class DataInsight {
  final playerUUID;
  final totalTimeSpent;
  final totalScore;
  final totalDiamonds;
  final totalShrinkers;
  final totalHearts;
  final totalLevelsCompleted;

  DataInsight({required this.totalTimeSpent, required this.playerUUID, required this.totalScore, required this.totalDiamonds, required this.totalShrinkers, required this.totalHearts, required this.totalLevelsCompleted});
  @override
  String toString() {
    return 'DataInsight{playerUUID: $playerUUID, totalTimeSpent: $totalTimeSpent, totalScore: $totalScore, totalDiamonds: $totalDiamonds, totalShrinkers: $totalShrinkers, totalHearts: $totalHearts, totalLevelsCompleted: $totalLevelsCompleted}';
  }
}

class User {
  final int id;
  String name;
  String country_code;
  String uuid;

  User({required this.id, required this.name, required this.country_code, required this.uuid});

  User.fromRow(Map<String, dynamic> map)
      : id = map[idColumn],
        name = map[nameColumn],
        country_code = map[countryCodeColumn],
        uuid = map[uuidColumn];

  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      nameColumn: name,
      countryCodeColumn: country_code,
      uuidColumn: uuid,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, country_code: $country_code, uuid: $uuid}';
  }
}

const idColumn = 'id';
const nameColumn = 'name';
const countryCodeColumn = 'country_code';
const uuidColumn = 'uuid';

class Level {
  final int id;
  String name;

  Level({required this.id, required this.name});

  Level.fromRow(Map<String, dynamic> map)
      : id = map[idColumn],
        name = map[nameColumn];

  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      nameColumn: name,
    };
  }

  @override
  String toString() {
    return 'Level{id: $id, name: $name}';
  }
}

const levelIdColumn = 'level_id';
const levelNameColumn = 'name';

class History {
  int id = 0;
  int diamonds;
  int hearts;
  int shrinkers;
  int level_id;
  int player_id;
  int health;
  int score;
  int time_elapsed;
  int date_time;

  /*
  Example:
   id: 1,
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
   */

  History({required this.diamonds, required this.hearts, required this.shrinkers, required this.level_id, required this.player_id, required this.health, required this.score, required this.time_elapsed, required this.date_time});

  History.fromRow(Map<String, dynamic> map)
      : id = map[idColumn],
        diamonds = map[diamondsColumn],
        hearts = map[heartsColumn],
        shrinkers = map[shrinkersColumn],
        level_id = map[levelIdColumn],
        player_id = map[playerColumn],
        health = map[healthColumn],
        score = map[scoreColumn],
        time_elapsed = map[timeElapsedColumn],
        date_time = map[dateTimeColumn];

  Map<String, dynamic> toMap() {
    return {
      //id colum was not included because it is autoincremented
      diamondsColumn: diamonds,
      heartsColumn: hearts,
      shrinkersColumn: shrinkers,
      levelIdColumn: level_id,
      playerColumn: player_id,
      healthColumn: health,
      scoreColumn: score,
      timeElapsedColumn: time_elapsed,
      dateTimeColumn: date_time,
    };
  }

  @override
  String toString() {
    return 'History{id: $id, diamonds: $diamonds, hearts: $hearts, shrinkers: $shrinkers, level_id: $level_id, player_id: $player_id, health: $health, score: $score, time_elapsed: $time_elapsed, date_time: $date_time}';
  }
}

const diamondsColumn = 'diamonds';
const heartsColumn = 'hearts';
const shrinkersColumn = 'shrinkers';
const healthColumn = 'health';
const scoreColumn = 'score';
const timeElapsedColumn = 'time_elapsed';
const dateTimeColumn = 'date_time';
const playerColumn = 'player_id';

//consts for db management

const dbName = 'maize_beta.db';
const profileTable = 'Profile_t';
const levelTable = 'Level_t';
const historyTable = 'History_t';
