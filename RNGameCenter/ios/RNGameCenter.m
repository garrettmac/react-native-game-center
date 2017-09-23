//
//  RNGameCenter.m
//  StockShot
//
//  Created by vyga on 9/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RNGameCenter.h"
#import <GameKit/GameKit.h>
#import <React/RCTUtils.h>
#import <React/RCTConvert.h>
#import <React/RCTLog.h>

//Global Defaults
NSString *_leaderboardIdentifier;
NSString *_achievementIdentifier;
NSString *_playerId;


@interface RNGameCenter ()

@property (nonatomic, strong) GKGameCenterViewController *gkView;
@property (nonatomic, strong) UIViewController *reactNativeViewController;
@property (nonatomic, strong) NSNumber *_currentAdditionCounter;
@end


@implementation RNGameCenter

  - (dispatch_queue_t)methodQueue{
      return dispatch_get_main_queue();
  }


RCT_EXPORT_MODULE()



/* -----------------------------------------------------------------------------------------------------------------------------------------
 Init Game Center
 -----------------------------------------------------------------------------------------------------------------------------------------*/


RCT_EXPORT_METHOD(init:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  //GKGameCenterViewController* gcViewController = [[GKGameCenterViewController alloc]init];
  if(options[@"leaderboardIdentifier"])_leaderboardIdentifier=options[@"leaderboardIdentifier"];
  else reject(@"Error", @"Error please pass your leaderboardIdentifier into init function",nil);
  

  if(options[@"achievementIdentifier"])_achievementIdentifier=options[@"achievementIdentifier"];

  
  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  localPlayer.authenticateHandler = ^(UIViewController *gcViewController, NSError *error){
     if (gcViewController != nil) {
      [rnView presentViewController:gcViewController animated:YES completion:nil];
    }else{
      if ([GKLocalPlayer localPlayer].authenticated) {
        // Get the default leaderboard identifier.
        [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {

          if (error != nil) {
            NSLog(@"%@",[error localizedDescription]);
            reject(@"Error", @"Error initiating Game Center make sure you are enrolled in the apple program, you set up a game center in itunes connect, and you registed it to the correct and matching app bundle id",error);
          }else{
                        //set to global
                        _leaderboardIdentifier=leaderboardIdentifier;
            resolve(@"init success");
          }
        }];
      }else{
        
        reject(@"Error", @"Error initiating Game Center Player",error);
      }
    }
  };
};




























/* -----------------------------------------------------------------------------------------------------------------------------------------
 Player
 -----------------------------------------------------------------------------------------------------------------------------------------*/




/* --------------getPlayer--------------*/

RCT_EXPORT_METHOD(getPlayer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  @try {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
      NSDictionary* user = @{
                             @"alias":localPlayer.alias,
                             @"displayName":localPlayer.displayName,
                             @"playerID":localPlayer.playerID,
                             @"alias":localPlayer.alias
                             };
      resolve(user);
}@catch (NSError * e) {
    reject(@"Error",@"Error getting user.", e);
  }
}
/* --------------getPlayerImage--------------*/
//

RCT_EXPORT_METHOD(getPlayerImage:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
   GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:
                    @"user.jpg" ];
  
  // Check if the user photo is cached
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
  
  if(fileExists){
    // Return it if it does
    resolve(path);
    
  }else{
    // Else load it from the game center
    [localPlayer loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
      
      if (photo != nil){
        NSData* data = UIImageJPEGRepresentation(photo, 0.8);
        [data writeToFile:path atomically:YES];
        resolve(path);
        
      }
      if (error != nil)
      {
        reject(@"Error", @"Error no user player Image",error);
      }
    }];
  }
}



RCT_EXPORT_METHOD(challengePlayers:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
//- (void) challengeViewController:(MyAchievementChallengeViewController*)controller wasDismissedWithChallenge:(BOOL)issued
  @try {
    NSArray *challengePlayerArray=options[@"players"];
    resolve(@"Successfully opened achievements");
  }
  @catch (NSError * e) {
    reject(@"Error",@"Error opening achievements.", e);
  }
//
//  [self dismissViewControllerAnimated:YES completion:NULL];
//  if (issued)
//  {
//
//  }
}


RCT_EXPORT_METHOD(challengeWithScore:(int64_t)playerScore
                  options:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
//  -(void) sendScoreChallengeToPlayers:(NSArray*)players withScore:(int64_t)score message:(NSString*)message {
  NSString *message = options[@"message"];
  NSArray *players = options[@"players"];
  NSString *achievementId;
  if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
    //1
    GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:achievementId];
    gkScore.value = playerScore;
  
    //2
   UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
    [gkScore issueChallengeToPlayers:players message:message];
  GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
//    [rnView presentViewController: leaderboardController animated: YES completion:nil];
  
  [rnView presentViewController:gkScore animated:YES completion:nil];
  
  //challengeComposeControllerWithMessage
//  }

}


//-(void) findScoresOfFriendsToChallenge {
  RCT_EXPORT_METHOD(findScoresOfFriendsToChallenge:(NSDictionary *)options
                    resolve:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject){
    
    // Get leaderboardIdentifier or use default leaderboardIdentifier
    NSString *achievementId;
    if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
    else achievementId=_achievementIdentifier;
  GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];
  leaderboard.identifier = achievementId;
  leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
  leaderboard.range = NSMakeRange(1, 100);
  [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
    BOOL success = (error == nil);
    
    if (success) {
//      if (!_includeLocalPlayerScore) {
//        NSMutableArray *friendsScores = [NSMutableArray array];
//        for (GKScore *score in scores) {
//          if (![score.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
//            [friendsScores addObject:score];
//          }
//        }
//        scores = friendsScores;
      resolve(scores);
      
    }else{
       reject(@"Error", @"Error scores",error);
    }
  }];
}




/* -----------------------------------------------------------------------------------------------------------------------------------------
 Leaderboard
  -----------------------------------------------------------------------------------------------------------------------------------------*/

/* --------------showLeaderboard--------------*/
//RCT_EXPORT_METHOD(showLeaderboard:(NSString *)leaderboardIdentifier
RCT_EXPORT_METHOD(showLeaderboard:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  //RCT_EXPORT_METHOD(showLeaderboard:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
  NSString *leaderboardId;
  if(options[@"leaderboardIdentifier"])leaderboardId=options[@"leaderboardIdentifier"];
  else leaderboardId=_leaderboardIdentifier;
  if (leaderboardController != NULL){
    leaderboardController.leaderboardIdentifier = leaderboardId;
    leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
    leaderboardController.gameCenterDelegate = self;
    [rnView presentViewController: leaderboardController animated: YES completion:nil];
    resolve(@"opened Leaderboard");
  }
}


/* --------------submitLeaderboardScore--------------*/


RCT_EXPORT_METHOD(submitLeaderboardScore:(int64_t)score
                  options:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  // Get leaderboardIdentifier or use default leaderboardIdentifier
  NSString *leaderboardId;
  if(options[@"leaderboardIdentifier"])leaderboardId=options[@"leaderboardIdentifier"];
  else leaderboardId=_leaderboardIdentifier;
  
  
  GKScore *scoreSubmitter = [[GKScore alloc] initWithLeaderboardIdentifier: leaderboardId];
  scoreSubmitter.value = score;
  scoreSubmitter.context = 0;
  
  [GKScore reportScores:@[scoreSubmitter] withCompletionHandler:^(NSError *error) {
    if (error)
    {
      reject(@"Error", @"Error submitting score",error);
    }else{
      resolve(@"Successfully submitted score");
    }
  }];
}



/* --------------getLeaderboardPlayers--------------*/

RCT_EXPORT_METHOD(getLeaderboardPlayers:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  //Get Player Ids
  NSArray *playerIds=options[@"playerIds"];
  //create Query with Player Ids
  GKLeaderboard *query = [[GKLeaderboard alloc] initWithPlayers:[NSArray arrayWithObject:playerIds]];

  if (query != nil){
    [query loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
      if (error != nil)reject(@"Error", @"Error getting players leaderboards",error);
      else  resolve(scores);
    }];
  }else{
    reject(@"Error", @"Error creating Leaderboard query",nil);
  }
}









/*
 -----------------------------------------------------------------------------------------------------------------------------------------
 Achievements
  -----------------------------------------------------------------------------------------------------------------------------------------
 */

/* --------------showAchievements--------------*/

RCT_EXPORT_METHOD(showAchievements: (NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  @try {
    GKGameCenterViewController* gcViewController = [[GKGameCenterViewController alloc]init];
    UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
    gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    // Get achievementIdentifier or use default achievementIdentifier
    NSString *achievementId;
    if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
    else achievementId=_achievementIdentifier;
    gcViewController.leaderboardIdentifier = achievementId;
    //attaches to class to allow dismissal
    gcViewController.gameCenterDelegate = self;
    [rnView presentViewController:gcViewController animated:YES completion:nil];
    resolve(@"Successfully opened achievements");
  }
  @catch (NSError * e) {
    reject(@"Error",@"Error opening achievements.", e);
  }
};



/* --------------getAchievements--------------*/

  RCT_EXPORT_METHOD(getAchievements: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  NSMutableArray *earntAchievements = [NSMutableArray array];
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
   {
     if (error == nil){
       for (GKAchievement* achievement in achievements)
       {
         NSMutableDictionary *entry = [NSMutableDictionary dictionary];
         entry[@"identifier"] = achievement.identifier;
         entry[@"percentComplete"] = [NSNumber numberWithDouble: achievement.percentComplete];
         entry[@"completed"] = [NSNumber numberWithBool:achievement.completed];
         entry[@"lastReportedDate"] = [NSNumber numberWithDouble:[achievement.lastReportedDate timeIntervalSince1970] * 1000];
         entry[@"showsCompletionBanner"] = [NSNumber numberWithBool:achievement.showsCompletionBanner];
//         entry[@"playerID"] = achievement.playerID;
         [earntAchievements addObject:entry];
       }
       
       resolve(earntAchievements);
       //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray: earntAchievements];
     }else{
        reject(@"Error", @"Error getting achievements",error);
//       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
     }
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
   }];
}



/* --------------resetAchievements--------------*/
RCT_EXPORT_METHOD(resetAchievements:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  // Clear all progress saved on Game Center.
  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  
  UIAlertController * alert = [UIAlertController
                               alertControllerWithTitle:@"Reset Achievements?"
                               message:@"Are you sure you want to reset your achievements. This can not be undone."
                               preferredStyle:UIAlertControllerStyleAlert];
  
   UIAlertController *yesAlert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                       message:@"You successfully reset your achievements!"
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
  [yesAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [yesAlert dismissViewControllerAnimated:YES completion:nil];
  }]];

  UIAlertAction* yesButton = [UIAlertAction
                              actionWithTitle:@"Reset"
                              style:UIAlertActionStyleDefault
                              
                              handler:^(UIAlertAction * action) {
                                //Handle your yes please button action here
                                [GKAchievement resetAchievementsWithCompletionHandler: ^ (NSError * error){
                                  if(error != nil) {reject(@ "Error", @ "Error resetting achievements", error);}
                                  else {
                                  [rnView presentViewController:yesAlert animated:YES completion:nil];
                                   resolve(@ "User Reset Achievements");
                                }
                              }];
                                  }];
                              
  UIAlertAction* noButton = [UIAlertAction
                             actionWithTitle:@"Nah!"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                               //Handle no, thanks button
                             }];
  
  [alert addAction:yesButton];
  [alert addAction:noButton];
  


   [rnView presentViewController:alert animated:YES completion:nil];
                                


}






/* --------------submitAchievement--------------*/

RCT_EXPORT_METHOD(submitAchievement:(NSDictionary *)options
                    resolve:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject){

  // Get achievementIdentifier or use default achievementIdentifier
  NSString *achievementId;
  if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
  else achievementId=_achievementIdentifier;
  
  //Get achievement progress percentage
    float percentComplete = [options[@"percentComplete"] floatValue];
//  float percentFloat = [percent floatValue];
  BOOL showsCompletionBanner;
  if(options[@"showsCompletionBanner"])showsCompletionBanner=YES;
  else showsCompletionBanner=NO;

  GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: achievementId];
  if (achievement){
    achievement.percentComplete = percentComplete;
    achievement.showsCompletionBanner = showsCompletionBanner;

    NSArray *achievements = [NSArray arrayWithObjects:achievement, nil];

    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
      if (error != nil){
         reject(@"Error", @"Error reporting achievement",error);
      }else{
        // Achievement notification banners are broken on iOS 7 so we do it manually here if 100%:
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
            [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 &&
            floorf(percentComplete) >= 100){
          [GKNotificationBanner showBannerWithTitle:@"Achievement" message:@"Completed!" completionHandler:^{}];
        }
        resolve(achievements);
      }
    }];
  }

}



//Enable the ability to close Achivments/Leaderboard Game Center Popup from React Native App
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)viewController{
  [viewController dismissViewControllerAnimated:YES completion:nil];
}
//Enable the ability to close Achivments/Leaderboard Game Center Popup from React Native App
- (void)gameCenterViewControllerDidCancel:(GKGameCenterViewController *)gameCenterViewController{
//- (void)gameCenterViewControllerDidCancel:(GKGameCenterViewController *)viewController{
  [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


//-(void)updateAchievements{
//  NSString *achievementIdentifier;
//  float progressPercentage = 0.0;
//  BOOL progressInLevelAchievement = NO;
//
//  GKAchievement *levelAchievement = nil;
//  GKAchievement *scoreAchievement = nil;
//
//  if (_currentAdditionCounter == 0) {
//    if (_level <= 3) {
//      progressPercentage = _level * 100 / 3;
//      achievementIdentifier = @"Achievement_Level3";
//      progressInLevelAchievement = YES;
//    }
//    else if (_level < 6){
//      progressPercentage = _level * 100 / 5;
//      achievementIdentifier = @"Achievement_Level5Complete";
//      progressInLevelAchievement = YES;
//    }
//  }
//
//  if (progressInLevelAchievement) {
//    levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
//    levelAchievement.percentComplete = progressPercentage;
//  }
//
//
//  if (_score <= 50) {
//    progressPercentage = _score * 100 / 50;
//    achievementIdentifier = @"Achievement_50Points";
//  }
//  else if (_score <= 120){
//    progressPercentage = _score * 100 / 120;
//    achievementIdentifier = @"Achievement_120Points";
//  }
//  else{
//    progressPercentage = _score * 100 / 180;
//    achievementIdentifier = @"Achievement_180Points";
//  }
//
//  scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
//  scoreAchievement.percentComplete = progressPercentage;
//
//  NSArray *achievements = (progressInLevelAchievement) ? @[levelAchievement, scoreAchievement] : @[scoreAchievement];
//
//  [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
//    if (error != nil) {
//      NSLog(@"%@", [error localizedDescription]);
//    }
//  }];
//}

//
//- (void)authenticateLocalPlayer
//{

//  [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
//
//    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"scoreLeaderboard"];
//    [score setValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]];
//
//    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
//      NSLog(@"Reporting Error: %@",error);
//    }];
//
//  }];
//}




/*
 https://github.com/garrettmac/react-native-tweet/blob/master/Tweet/ios/RNTweet.m
 */


/*
 //NSError *jsonError;
 //  NSDictionary *json = [NSJSONSerialization
 //                        JSONObjectWithData:localPlayer
 //                        options:0
 //                        error:&jsonError];
 //NSDictionary *json = @{@"localPlayer":localPlayer};



 NSString *leaderboardIdentifier = @"StockShotLeaderboard";*/
/*
 GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
 localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
 if (viewController != nil) {
 [self presentViewController:viewController animated:YES completion:nil];
 }
 else{
 if ([GKLocalPlayer localPlayer].authenticated) {
 _gameCenterEnabled = YES;

 // Get the default leaderboard identifier.
 [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {

 if (error != nil) {
 NSLog(@"%@", [error localizedDescription]);
 }
 else{
 _leaderboardIdentifier = leaderboardIdentifier;
 }
 }];
 }

 else{
 _gameCenterEnabled = NO;
 }
 }
 };*/







/*



 -(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
 {
 [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
 }
 */


/*

 -(void)updateAchievements{
 NSString *achievementIdentifier;
 float progressPercentage = 0.0;
 BOOL progressInLevelAchievement = NO;

 GKAchievement *levelAchievement = nil;
 GKAchievement *scoreAchievement = nil;

 if (_currentAdditionCounter == 0) {
 if (_level <= 3) {
 progressPercentage = _level * 100 / 3;
 achievementIdentifier = @"Achievement_Level3";
 progressInLevelAchievement = YES;
 }
 else if (_level < 6){
 progressPercentage = _level * 100 / 5;
 achievementIdentifier = @"Achievement_Level5Complete";
 progressInLevelAchievement = YES;
 }
 }

 if (progressInLevelAchievement) {
 levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
 levelAchievement.percentComplete = progressPercentage;
 }


 if (_score <= 50) {
 progressPercentage = _score * 100 / 50;
 achievementIdentifier = @"Achievement_50Points";
 }
 else if (_score <= 120){
 progressPercentage = _score * 100 / 120;
 achievementIdentifier = @"Achievement_120Points";
 }
 else{
 progressPercentage = _score * 100 / 180;
 achievementIdentifier = @"Achievement_180Points";
 }

 scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
 scoreAchievement.percentComplete = progressPercentage;

 NSArray *achievements = (progressInLevelAchievement) ? @[levelAchievement, scoreAchievement] : @[scoreAchievement];

 [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
 if (error != nil) {
 NSLog(@"%@", [error localizedDescription]);
 }
 }];
 }
 */


/*

 -(void)updateAchievements{
 NSString *achievementIdentifier;
 float progressPercentage = 0.0;
 BOOL progressInLevelAchievement = NO;

 GKAchievement *levelAchievement = nil;
 GKAchievement *scoreAchievement = nil;

 if (_currentAdditionCounter == 0) {
 if (_level <= 3) {
 progressPercentage = _level * 100 / 3;
 achievementIdentifier = @"Achievement_Level3";
 progressInLevelAchievement = YES;
 }
 else if (_level < 6){
 progressPercentage = _level * 100 / 5;
 achievementIdentifier = @"Achievement_Level5Complete";
 progressInLevelAchievement = YES;
 }
 }

 if (progressInLevelAchievement) {
 levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
 levelAchievement.percentComplete = progressPercentage;
 }


 if (_score <= 50) {
 progressPercentage = _score * 100 / 50;
 achievementIdentifier = @"Achievement_50Points";
 }
 else if (_score <= 120){
 progressPercentage = _score * 100 / 120;
 achievementIdentifier = @"Achievement_120Points";
 }
 else{
 progressPercentage = _score * 100 / 180;
 achievementIdentifier = @"Achievement_180Points";
 }

 scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
 scoreAchievement.percentComplete = progressPercentage;

 NSArray *achievements = (progressInLevelAchievement) ? @[levelAchievement, scoreAchievement] : @[scoreAchievement];

 [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
 if (error != nil) {
 NSLog(@"%@", [error localizedDescription]);
 }
 }];
 }
 */

/*

 -(void)resetAchievements{
 [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
 if (error != nil) {
 NSLog(@"%@", [error localizedDescription]);
 }
 }];
 }

 */

/*
 - (IBAction)showGCOptions:(id)sender {
 ...

 [_customActionSheet showInView:self.view
 withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {
 if ([buttonTitle isEqualToString:@"View Leaderboard"]) {
 ...
 }
 else if ([buttonTitle isEqualToString:@"View Achievements"]) {
 ...
 }
 else{
 [self resetAchievements];
 }
 }];
 ....
 }
 */


/*
 - (IBAction)showGCOptions:(id)sender {
 ...
 [_customActionSheet showInView:self.view
 withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {

 if ([buttonTitle isEqualToString:@"View Leaderboard"]) {
 [self showLeaderboardAndAchievements:YES];
 }
 else if ([buttonTitle isEqualToString:@"View Achievements"]) {
 [self showLeaderboardAndAchievements:NO];
 }
 else{

 }
 }];
 ...
 }*/
@end



/*



 #import "GameCenterPlugin.h"
 #import <Cordova/CDVViewController.h>

 #define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

 @interface GameCenterPlugin ()
 @property (nonatomic, retain) GKLeaderboardViewController *leaderboardController;
 @property (nonatomic, retain) GKAchievementViewController *achievementsController;
 @end

 @implementation GameCenterPlugin

 - (void)dealloc {
 self.leaderboardController = nil;
 self.achievementsController = nil;

 [super dealloc];
 }

 - (void)authenticateLocalPlayer:(CDVInvokedUrlCommand *)command {

 [self.commandDelegate runInBackground:^{

 if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
 [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
 if (error == nil) {
 CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 } else {
 CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 }
 }];
 } else {
 [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewcontroller, NSError *error) {
 CDVPluginResult *pluginResult;

 if ([GKLocalPlayer localPlayer].authenticated) {
 // Already authenticated
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 } else if (viewcontroller) {
 // Present the login view

 CDVViewController *cont = (CDVViewController *)[super viewController];
 [cont presentViewController:viewcontroller animated:YES completion:^{
 [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
 }];

 } else {
 // Called the second time with result
 if (error == nil) {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 } else {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
 }
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

 }

 }];
 }
 }];
 }

 - (void)reportScore:(CDVInvokedUrlCommand *)command {

 [self.commandDelegate runInBackground:^{
 NSString *category = (NSString *) [command.arguments objectAtIndex:0];
 int64_t score = [[command.arguments objectAtIndex:1] integerValue];

 GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
 scoreReporter.value = score;

 [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
 CDVPluginResult *pluginResult;
 if (!error) {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 } else {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
 }
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 }];
 }];
 }

 - (void)showLeaderboard:(CDVInvokedUrlCommand *)command {
 [self.commandDelegate runInBackground:^{
 if ( self.leaderboardController == nil ) {
 self.leaderboardController = [[GKLeaderboardViewController alloc] init];
 self.leaderboardController.leaderboardDelegate = self;
 }

 self.leaderboardController.category = (NSString *) [command.arguments objectAtIndex:0];
 CDVViewController *cont = (CDVViewController *)[super viewController];
 [cont presentViewController:self.leaderboardController animated:YES completion:^{
 [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
 }];
 }];
 }

 - (void)showAchievements:(CDVInvokedUrlCommand *)command {
 [self.commandDelegate runInBackground:^{
 if ( self.achievementsController == nil ) {
 self.achievementsController = [[GKAchievementViewController alloc] init];
 self.achievementsController.achievementDelegate = self;
 }

 CDVViewController *cont = (CDVViewController *)[super viewController];
 [cont presentViewController:self.achievementsController animated:YES completion:^{
 [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
 }];
 }];
 }

 - (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
 CDVViewController *cont = (CDVViewController *)[super viewController];
 [cont dismissViewControllerAnimated:YES completion:nil];
 [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
 }

 - (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
 CDVViewController* cont = (CDVViewController *)[super viewController];
 [cont dismissViewControllerAnimated:YES completion:nil];
 [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
 }

 - (void)reportAchievementIdentifier:(CDVInvokedUrlCommand *)command {
 [self.commandDelegate runInBackground:^{
 NSString *identifier = (NSString *) [command.arguments objectAtIndex:0];
 float percent = [[command.arguments objectAtIndex:1] floatValue];

 GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
 if (achievement) {
 achievement.percentComplete = percent;
 [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
 CDVPluginResult *pluginResult;
 if (!error) {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 } else {
 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
 }
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 }];
 } else {
 CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to alloc GKAchievement"];
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 }
 }];
 }

 @end


 */
