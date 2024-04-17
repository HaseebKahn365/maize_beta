# maize_beta

this is a base project for the maize app. here we will start off by testing the player moment using the gyroscope sensor.

## Getting Started

This project is a starting point for a Flutter application.

https://flagsapi.com/#sizes was used for getting the flags of the countries.



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
Here the document will represent each level the toppers of each level. This document maintains the top 10 players of the level and also their 



Here we are going to design the documents and collection in a way that would make it easy for us to fetch the necessary data for the Journey Screen and LeaderBoard Screen.
The topper players in each document of the level will be listed in order based on the following criteria:
{
    Shotest time to complete the level
    Most % of life remaining
    Most score
}

First lets setup the design for levels collection. Here we will store the top 10 players for each level as well as the threshold for 
100th
200th
300th
400th
500th
600th
700th
800th
900th
1000th position. each of these thresholds will be based on the following data:
{
    Shotest time to complete the level
    Most % of life remaining
    Most score
} 