//Here we are going to use the sqflite package to create and manage the db.
/*
Here is what the structure of the db tables look like:

CREATE TABLE `Profile_t` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`name`	INTEGER NOT NULL DEFAULT 'Anon',
	`country_code`	TEXT DEFAULT 'ps'
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

class User {
  final int id;
  String name;
  String country_code;

  User({required this.id, required this.name, required this.country_code});

  User.fromRow(Map<String, dynamic> map)
      : id = map[idColumn],
        name = map[nameColumn],
        country_code = map[countryCodeColumn];

  @override
  String toString() {
    return 'User{id: $id, name: $name, country_code: $country_code}';
  }
}

const idColumn = 'id';
const nameColumn = 'name';
const countryCodeColumn = 'country_code';

class Level {
  final int id;
  String name;

  Level({required this.id, required this.name});

  Level.fromRow(Map<String, dynamic> map)
      : id = map[idColumn],
        name = map[nameColumn];

  @override
  String toString() {
    return 'Level{id: $id, name: $name}';
  }
}

const levelIdColumn = 'level_id';
const levelNameColumn = 'name';

class History {
  final int id;
  int diamonds;
  int hearts;
  int shrinkers;
  int level_id;
  int player_id;
  int health;
  int score;
  int time_elapsed;
  int date_time;

  History({required this.id, required this.diamonds, required this.hearts, required this.shrinkers, required this.level_id, required this.player_id, required this.health, required this.score, required this.time_elapsed, required this.date_time});

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
