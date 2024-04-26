/*

Database design for firestore.
we are gonna have three collection in the firestore database.
1. Users
2. Levels
3. LeaderBoard

### Users
Here the document will represent each user. The document will have the following fields:
1. name
2. country_code
3. other properties that we might need in the future.

### Levels
Here the document will represent each level the toppers of each level. This document maintains the top 10 players of the level and also their details like:
{least time to complete the level
most % of life remaining
most score
player_uuid
}

later on after the top 10 fields we will have 10 more fields that are designed to not store details of the particular players but to store the threshold for the 100th, 200th, 300th, 400th, 500th, 600th, 700th, 800th, 900th, 1000th position. each of these thresholds will be based on the following data:
{
    Shotest time to complete the level
    Most % of life remaining
    Most score
    total_participants //these are the number of players in <100 position. while checking for thresholds, we must fill the top 100 number of participants before moving on to check for the top 200 threshold. this field is essential to identify the position of the player even if he is not in the top 10. 


    if a player is elegible for this threshold this will be incremented by 1 until it reaches 100. In case if there are already 100 players in the top 100 then the count of participants  of the top 200 will be incremented and so on.  
}

### LeaderBoard
The leaderboard is update every two day. it stores the records of the top 10 players and their details like:
{
    most no. of levels completed within the two days
    most no. of collectables collected within the two days
    most score within the two days
} 



#### Definining the structure and rules for the levels collection: {toppers}
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


#### Defining the structure and rules for the leaderboard collection: {toppers}
1. The document id will be the date of the leaderboard.
2. if the leaderboard document is not present then create it
3. if the leaderboard document is present then check if the player is in the top 10 or not.
4. Start comparing the player with the first row in the document. if the document is empty then add the current player to the top 1.
5. if the document is not empty then compare the player with the first row. if the player is better than the first row then replace the uid of that player with the current player without moving the rest of the rows down by one position.
6. if the player is not better than the first row then compare the player with the second row and so on.
7. if the player is not better than any of the top 10 players then do nothing.
Comparison is made based on the following criteria:
{
    most no. of levels completed within the two days from the document uid which is a timestamp
    most no. of collectables collected within the two days
    most score within the two days
}
8. In case if the app detects that the two days have passed then the leaderboard will be updated by deleting the old document and creating a new document with the current date as the document id.
9. The leaderboard will be updated every two days from the application side. 

### Lets start by creating the firestore database based on the above design.

*/


  //test method for levels collection
  /*#### Definining the structure and rules for the levels collection: {toppers}
1. The document id will be the level number.
2. if the level document is not present then create it
3. if the level document is present then check if the player is in the top 10 or not. 
4. Start comparing the player with the first row in the document. if the document is empty then add the current player to the top 1.
5. if the document is not empty then compare the player with the first row. if the player is better than the first row then replace the uid of that player with the current player and move the rest of the rows down by one position {this will cause alot of overhead so we will have to just replace that player with uuid of the current player.}
6. if the player is not better than the first row then compare the player with the second row and so on.
7. if the player is not better than any of the top 10 players then check if the player is eligible for the threshold. if the player is eligible for the threshold then increment the count of the participants of that threshold.
8. if the player is not eligible for any of the thresholds then do nothing. */

//## A generic structure of the document for the levels collection
/*

1st field: it has a key = 1 and value is a Map<String dynamic> with the following fields:
1 : {
    'uuid': 'player_uuid',
    'time': 'least time to complete the level',
    'life': 'most % of life remaining',
    'score': 'most score',
}

2nd field: it has a key = 2 and value is a Map<String dynamic> with the following fields:
2 : {
    'uuid': 'player_uuid',
    'time': 'least time to complete the level',
    'life': 'most % of life remaining',
    'score': 'most score',
    } ... and so on till 10th field.


11th field: it has a key = 100 and value is a Map<String dynamic> with the following fields:
100 : {
    'time': 'Shotest time to complete the level',
    'life': 'Most % of life remaining',
    'score': 'Most score',
    'total_participants': 'total_participants'
}

12th field: it has a key = 200 and value is a Map<String dynamic> with the following fields:
200 : {
    'time': 'Shotest time to complete the level',
    'life': 'Most % of life remaining',
    'score': 'Most score',
    'total_participants': 'total_participants'
} ... and so on till 1000th field.


### Structure of the leaderboard collection
There is only one document in the leaderboard collection. 
The document id will be the date of the leaderboard.
The document contains the following fields:
{
    1: {
        'uuid': 'player_uuid',
        'levels': 'most no. of levels completed within the two days',
        'collectables': 'most no. of collectables collected within the two days',
        'score': 'most score within the two days',
    }
    2: {
        'uuid': 'player_uuid',
        'levels': 'most no. of levels completed within the two days',
        'collectables': 'most no. of collectables collected within the two days',
        'score': 'most score within the two days',
    } ... and so on till 10th field.
}

 */

//Now that the structure is defined, we should start testing our design.
//The aim is to minimize the downloads from the firestore database.

//Here we create a method that will simply create mock documents [level toppers] for the first 10 levels of the game.
 