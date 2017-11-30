

import { NativeModules } from 'react-native';

// const { RNGameCenter as ReactNativeGameCenter } = NativeModules;

const RNGameCenter = {
  init: (options) => {
    // required: achievementIdentifier
    // optional: leaderboardIdentifier
    // {achievementIdentifier:""
    // leaderboardIdentifier:""}

    return NativeModules.RNGameCenter.init(options)
  },


  getPlayer: () => {
    return NativeModules.RNGameCenter.getPlayer()
  },
  getPlayerFriends: () => {
    return NativeModules.RNGameCenter.getPlayerFriends()
  },
  getPlayerImage: () => {
    return NativeModules.RNGameCenter.getPlayerImage()
  },




  // challengeWithScore:(options)=>{
  //   if(!options.score)throw "Missing 'score' from challengeWithScore object";
  // return  NativeModules.RNGameCenter.challengeWithScore(options.score,options)
  // },
  // findScoresOfFriendsToChallenge:()=>{
  // return  NativeModules.RNGameCenter.findScoresOfFriendsToChallenge({})
  // },


  // https://developer.apple.com/documentation/gamekit/gkscore
  openLeaderboardModal: (options) => {
    //props
    //leaderboardIdentifier or Defaults back to init leaderboardIdentifier
    return NativeModules.RNGameCenter.openLeaderboardModal(options)
  },
  submitLeaderboardScore: (options) => {
    //optional: leaderboardIdentifier or Defaults back to init leaderboardIdentifier
    //required: score

    if (!options.score) throw "Missing 'score' from submitLeaderboardScore object";
    else return NativeModules.RNGameCenter.submitLeaderboardScore(options.score, options)
  },

  // getLeaderboardPlayers:(options)=>{
  //
  //   //playerIds (Array)
  //   if(!options.playerIds)throw "Missing 'playerIds' from getLeaderboardPlayers object";
  //   if(!Array.isArray(options.playerIds))throw "getLeaderboardPlayers's 'playerIds' paramenter should be an array";
  // return  NativeModules.RNGameCenter.getLeaderboardPlayers(options)
  // },






  // https://developer.apple.com/documentation/gamekit/gkachievement
  openAchievementModal: (options = {}) => {

    return NativeModules.RNGameCenter.openAchievementModal(options)
  },

  getAchievements: () => {
    //null
    return NativeModules.RNGameCenter.getAchievements()
  },

  resetAchievements: (options = {}) => {

    return NativeModules.RNGameCenter.resetAchievements(options)
  },


  //         entry[@"playerID"] = achievement.playerID;
  // [earntAchievements addObject:entry];
  submitAchievementScore: (options) => {
    //optional
    //showsCompletionBanner (boolean)
    // achievementIdentifier (optional, reverts to default)
    //required
    // percentComplete (number/float 1-100)
    if (!options.percentComplete) throw "Missing 'percentComplete' from submitAchievementScore object";
    // if(!options.showsCompletionBanner)
    return NativeModules.RNGameCenter.submitAchievementScore(options)
    // return  NativeModules.RNGameCenter.submitAchievementScore(options.percentComplete,options)

  },
  getLeaderboardPlayers(options) {
    return NativeModules.RNGameCenter.getLeaderboardPlayers(options)
  },
  getTopLeaderboardPlayers(options) {
    return NativeModules.RNGameCenter.getTopLeaderboardPlayers(options)
  }
};






export default RNGameCenter

/*

Reason behind not just returning
_____________________
_____________________
ERROR OR BUG:
where you have to pass the `int64_t` score value in the method header
or it declares the score as the same -5,XXX,XXX,XXX,XXX,XXX,XXX value.

NOTE: int64_t range is (-9,223,372,036,854,775,808 to +9,223,372,036,854,775,807)
  Example:
  _____________________
    RCT_EXPORT_METHOD(submitLeaderboardScore:(int64_t)score
  _____________________
     and connot declare inside like
  _____________________
    int64_t scoreInt = (int64_t)options[@"score"];
  _____________________
  also tried all the following:
  _____________________
  int score = [userScore intValue];
  NSNumber *nsNum = options[@"score"];
  int intValueNum = [options[@"score"] intValue];
  int i = 1;
  int64_t scoreValue =(int64_t)i;
  int scoreValue =[options[@"score"] intValue];
  float floatNum = options[@"score"];
  int64 *sscore =[RCTConvert int64:options[@"score"]];
  NSInteger i = 34;
  NSNumber* numpre = [options valueForKey:@"score"];
  int scoreIn = (int)options[@"score"];
*/



/*
//TODO coming soon
getLeaderboardPlayers(){

  let options = {playerIds:[]};

  _GameCenter.getLeaderboardPlayers(options)
}



invite(){
  let options = {playerIds:[]};
  _GameCenter.invite(options)
}

challengeComposer(){

  let options = {score:this.state.score,
    message:"my message",
    players:["G:8135064222"],
    achievementIdentifier:"novice_award"
  };

  _GameCenter.challengeComposer(options)
    .then(console.log)
  .catch(console.warn)
}



findScoresOfFriendsToChallenge(){
  _GameCenter.findScoresOfFriendsToChallenge()
    .then(console.log)
  .catch(console.warn)
}

loadLeaderboardPlayers(){
  _GameCenter.loadLeaderboardPlayers()
    .then(console.log)
  .catch(console.warn)
}



*/
