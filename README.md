<p align="center"><img alt="react-native-game-center" src="snapshots/react-native-game-center.jpg" width="308"></p><p align="center">Meet react-native-game-center</p><p align="center"><a href="http://standardjs.com/"><img  src="https://img.shields.io/badge/code style-standard-brightgreen.svg?style=flat-square"></a><a href="http://standardjs.com/"><img  src="https://img.shields.io/github/downloads/atom/atom/latest/total.svg"></a><a href="https://npmjs.org/package/react-native-game-center"><img alt="npm version" src="http://img.shields.io/npm/v/react-native-game-center.svg?style=flat-square"></a><a href="https://npmjs.org/package/react-native-game-center"><img alt="npm version" src="http://img.shields.io/npm/dm/react-native-game-center.svg?style=flat-square"></a><a href="https://github.com/garrettmac/react-native-game-center/pulls?q=is:pr is:closed"><img alt="PR Stats" src="https://img.shields.io/issuestats/i/github/garrettmac/react-native-game-center.svg?style=flat-square"></a><a href="https://github.com/garrettmac/react-native-game-center/issues?q=is:issue is:closed"><img alt="Issue Stats" src="https://img.shields.io/issuestats/p/github/garrettmac/react-native-game-center.svg" style="flat-square"></a>   <a><img  src="https://img.shields.io/github/forks/garrettmac/react-native-game-center.svg"/></a><a><img  src="https://img.shields.io/github/stars/garrettmac/react-native-game-center.svg"/></a><a><img  src="https://img.shields.io/badge/license-MIT-blue.svg"/><a><img  src="https://img.shields.io/twitter/url/https/github.com/garrettmac/react-native-game-center.svg?style=social"></a><a href="https://gitter.im/garrettmac/react-native-game-center?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img alt="Join the chat" src="https://badges.gitter.im/garrettmac/react-native-game-center.svg"></a></p>

# react-native-game-center

## Getting Started



## Installation

- Install `react-native` first

```bash
npm i react-native -g
react-native init myApp
cd myApp
yarn add react-native-game-center
react-native link
react-native run-ios
```

## Set Up
> See [SETUP.md](SETUP.md)


### Example

or clone the repo and play with the example project

```bash
$ git clone https://github.com/garrettmac/react-native-game-center
$ cd react-native-game-center/GameCenterExample
$ yarn install
$ npm start
```
### Basic Usage

- In your `index.js`, use:
```bash
import RNGameCenter from "react-native-game-center"

RNGameCenter.getPlayer().then(player=>console.log("player: ",player))
```


## User

getUser | {displayName,playerID,alias,image}

## Achievements

| Method            | Required Parameters | Optional Parameters                         | Success Return Value                                                          | Fail Return Value            |
|-------------------|---------------------|---------------------------------------------|-------------------------------------------------------------------------------|------------------------------|
| showAchievements  | none                | achievementIdentifier                       | Successfully opened achievements                                              | Error opening achievements   |
| getAchievements   | none                | none                                        | {identifier,percentComplete,completed,lastReportedDate,showsCompletionBanner} | Error getting achievements   |
| resetAchievements | none                | none                                        | Reset achievements                                                            | Error resetting achievements |
| submitAchievement | percentComplete     | achievementIdentifier,showsCompletionBanner | Successfully submitted score                                                  | Error submitting score       |





## Leaderboard

| Method            | Required Parameters | Optional Parameters                         | Success Return Value                                                          | Fail Return Value            |
|-------------------|---------------------|---------------------------------------------|-------------------------------------------------------------------------------|------------------------------|
| showLeaderboard   | none                | leaderboardIdentifier                       | Successfully opened leaderboard                                              | Error opening leaderboard   |
| getLeaderboardPlayers   | playerIds (array of player ids)                | none                       | array of players                                              | Error creating Leaderboard query / Error getting players leaderboards   |
| getLeaderboard   | none                | none                                        | | Error getting leaderboard   |
| resetLeaderboard | none                | none                                        | Reset leaderboard                                                            | Error resetting leaderboard |
| submitLeaderboardScore | score     | leaderboardIdentifier | Successfully submitted score                                                  | Error submitting score       |
You can now import Markdown table code directly using File/Paste table data... dialog.
