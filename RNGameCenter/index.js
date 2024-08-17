import { NativeModules } from 'react-native';

// const { RNGameCenter as ReactNativeGameCenter } = NativeModules;
//standardizes the way options are validated
const validateOptions = (options, requiredFields) => {
  requiredFields.forEach(field => {
    if (!options[field]) {
      throw new Error(`Missing '${field}' from options object`);
    }
  });
};
const RNGameCenter = {
  init: async (options) => {
    try {
      return await NativeModules.RNGameCenter.init(options);
    } catch (error) {
      console.error('Error initializing Game Center:', error);
      throw error;
    }
  },

  userLogged:async () => {
    try {
      return await NativeModules.RNGameCenter.userLogged();
    } catch (error) {
      console.error('Error checking user logged status:', error);
      throw error;
    }
  },

  getPlayer:async () => {
    try {
      return await NativeModules.RNGameCenter.getPlayer();
    } catch (error) {
      console.error('Error getting player:', error);
      throw error;
    }
  },

  getPlayerFriends:async () => {
    try {
      return await NativeModules.RNGameCenter.getPlayerFriends();
    } catch (error) {
      console.error('Error getting player friends:', error);
      throw error;
    }
  },

  getPlayerImage:async () => {
    try {
      return await NativeModules.RNGameCenter.getPlayerImage();
    } catch (error) {
      console.error('Error getting player image:', error);
      throw error;
    }
  },

  // challengeWithScore:(options)=>{
  //   if(!options.score)throw "Missing 'score' from challengeWithScore object";
  // return  NativeModules.RNGameCenter.challengeWithScore(options.score,options)
  // },
  // findScoresOfFriendsToChallenge:()=>{
  // return  NativeModules.RNGameCenter.findScoresOfFriendsToChallenge({})
  // },

  // https://developer.apple.com/documentation/gamekit/gkscore
  openLeaderboardModal:async (options) => {
    try {
      return await NativeModules.RNGameCenter.openLeaderboardModal(options);
    } catch (error) {
      console.error('Error opening leaderboard modal:', error);
      throw error;
    }
  },
  submitLeaderboardScore: async (options) => {
    try {
      validateOptions(options, ['score']);
      return await NativeModules.RNGameCenter.submitLeaderboardScore(options.score, options);
    } catch (error) {
      console.error('Error submitting leaderboard score:', error);
      throw error;
    }
  },

  // getLeaderboardPlayers:(options)=>{
  //
  //   //playerIds (Array)
  //   if(!options.playerIds)throw "Missing 'playerIds' from getLeaderboardPlayers object";
  //   if(!Array.isArray(options.playerIds))throw "getLeaderboardPlayers's 'playerIds' paramenter should be an array";
  // return  NativeModules.RNGameCenter.getLeaderboardPlayers(options)
  // },

  // https://developer.apple.com/documentation/gamekit/gkachievement
  openAchievementModal:async (options = {}) => {
    try {
      return await NativeModules.RNGameCenter.openAchievementModal(options);
    } catch (error) {
      console.error('Error opening achievement modal:', error);
      throw error;
    }
  },

  getAchievements:async () => {
    try {
      return await NativeModules.RNGameCenter.getAchievements();
    } catch (error) {
      console.error('Error getting achievements:', error);
      throw error;
    }
  },

  resetAchievements:async (options = {}) => {
    try {
      return await NativeModules.RNGameCenter.resetAchievements(options);
    } catch (error) {
      console.error('Error resetting achievements:', error);
      throw error;
    }
  },

  // entry[@"playerID"] = achievement.playerID;
  // [earntAchievements addObject:entry];
  submitAchievementScore:async (options) => {
    try {
      validateOptions(options, ['percentComplete']);
      return await NativeModules.RNGameCenter.submitAchievementScore(options);
    } catch (error) {
      console.error('Error submitting achievement score:', error);
      throw error;
    }
  },

  uploadSavedGameData:async (options) => {
    try {
      return await NativeModules.RNGameCenter.uploadSavedGameData(options);
    } catch (error) {
      console.error('Error uploading saved game data:', error);
      throw error;
    }
  },

  loadSavedGameData: async (options) => {
    try {
      return await NativeModules.RNGameCenter.loadSavedGameData(options);
    } catch (error) {
      console.error('Error loading saved game data:', error);
      throw error;
    }
  },
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
