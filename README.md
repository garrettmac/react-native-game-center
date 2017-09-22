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

RNGameCenter.init().then(player=>console.log("player: ",player))
```


|Methods| Params | Description|
|----|----|
| authenticateLocalPlayer | | authenticateLocalPlayer |
| init | | init |
| updateAchievements | | updateAchievements |
| resetAchievements | | resetAchievements |
| showLeaderboard | | showLeaderboard |
| reportScore | | reportScore |
