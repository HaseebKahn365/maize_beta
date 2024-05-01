# maize_beta

this is a base project for the maize app. here we will start off by testing the player moment using the gyroscope sensor.

## Getting Started

This project is a starting point for a Flutter application.

https://flagsapi.com/#sizes was used for getting the flags of the countries.



# Software Requirements Specification for Puzzle Game

## 1. Introduction
### 1.1 Purpose
The purpose of this document is to outline the requirements for a puzzle game that uses a Firestore database to store user data, level data, and leaderboard data.

### 1.2 Document Conventions
This document follows the standard conventions for a Software Requirements Specification (SRS).

### 1.3 Intended Audience and Reading Suggestions
This document is intended for game developers, project managers, testers, and users of the puzzle game.

### 1.4 Project Scope
The puzzle game will be a fun and engaging game for users of all ages. The game will involve solving puzzles of varying difficulty levels.

### 1.5 References
Flags API: https://flagsapi.com/#sizes

## 2. Overall Description
### 2.1 Product Perspective
The puzzle game will be a standalone application that can be installed and played on various platforms.

### 2.2 Product Functions
The main function of the product is to provide entertainment through puzzle-solving activities. The game will also track user progress and display a leaderboard.

### 2.3 User Classes and Characteristics
The game is intended for users of all ages who enjoy puzzle games.

### 2.4 Operating Environment
The game will be developed to be compatible with various operating systems.

### 2.5 Design and Implementation Constraints
The game should be designed to be intuitive and user-friendly. It should also be lightweight and not consume excessive system resources.

## 3. System Features
### 3.1 System Feature 1: User Data Storage
#### 3.1.1 Description and Priority
High priority. The game needs to store user data, including name and country code.

### 3.2 System Feature 2: Level Data Storage
#### 3.2.1 Description and Priority
High priority. The game needs to store level data, including the top 10 players for each level and their details.

### 3.3 System Feature 3: Leaderboard Data Storage
#### 3.3.1 Description and Priority
High priority. The game needs to store leaderboard data, including the top 10 players and their details.

## 4. External Interface Requirements
### 4.1 User Interfaces
The game will have a graphical user interface that is intuitive and easy to navigate.

### 4.2 Hardware Interfaces
The game will be played using a keyboard and mouse.

### 4.3 Software Interfaces
The game will interact with the Firestore database for storing and retrieving user data, level data, and leaderboard data.

## 5. Other Nonfunctional Requirements
### 5.1 Performance Requirements
The game should load quickly and run smoothly without lagging.

### 5.2 Safety Requirements
The game should not contain any content that is inappropriate for children.

### 5.3 Security Requirements
User data should be stored securely.

### 5.4 Software Quality Attributes
The game should be reliable, maintainable, and user-friendly.

## 6. Other Requirements
The leaderboard should be updated every two days.




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