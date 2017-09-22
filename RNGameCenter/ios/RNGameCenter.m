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


NSString *_leaderboardIdentifier;
//NSBOOL *_gameCenterEnabled;


@interface RNGameCenter ()

@property (nonatomic, strong) GKGameCenterViewController *gkView;
@property (nonatomic, strong) UIViewController *reactNativeViewController;
@property (nonatomic, strong) NSNumber *_currentAdditionCounter;
//@property (nonatomic, strong) UIAlertController *alertController;
//@property (nonatomic, strong) UIImagePickerController *picker;
//@property (nonatomic, strong) RCTResponseSenderBlock callback;
//@property (nonatomic, strong) NSDictionary *defaultOptions;
//@property (nonatomic, retain) NSMutableDictionary *options, *response;
//@property (nonatomic, strong) NSArray *customButtons;

@end

//@property (nonatomic, assign) BOOL _gameCenterEnabled;
@implementation RNGameCenter
- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}


RCT_EXPORT_MODULE()



//RCT_EXPORT_METHOD(showLeaderboard: (NSString *)name
//                  (RCTPromiseResolveBlock)resolve
//                  rejecter:(RCTPromiseRejectBlock)reject)



//  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
//  [rnView presentViewController:gcViewController animated:YES completion:nil];
RCT_EXPORT_METHOD(init:(NSString *)leaderboardIdentifier
                  //RCT_EXPORT_METHOD(authenticateLocalPlayer: (RCTPromiseResolveBlock)resolve
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  GKGameCenterViewController* gcViewController = [[GKGameCenterViewController alloc]init];
  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  _leaderboardIdentifier=leaderboardIdentifier;
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
            reject(@"Error", @"Error initiating Player",error);
          }else{
            __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

                        _leaderboardIdentifier=leaderboardIdentifier;
//            GKLocalPlayer *player = [GKLocalPlayer localPlayer];
            NSDictionary* user = @{
                                   @"alias":localPlayer.alias,
                                   @"displayName":localPlayer.displayName,
                                   @"playerID":localPlayer.playerID
                                   };
//            NSDictionary *json = [RCTConvert NSDictionary:player];
//            NSLog(@"user json %@", json);
            RCTLog(@"user json %@", user);
            resolve(user);
          }
        }];
      }else{
        /*_gameCenterEnabled=NO;*/
        reject(@"Error", @"Error initiating Player",error);
      }
    }
  };//localPlayer.authenticateHandler
};//RCT_EXPORT_METHOD




RCT_EXPORT_METHOD(showLeaderboard:(NSString *)leaderboardIdentifier
                resolve:(RCTPromiseResolveBlock)resolve
//RCT_EXPORT_METHOD(showLeaderboard:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];

  if (leaderboardController != NULL)
  {
    leaderboardController.leaderboardIdentifier = leaderboardIdentifier;
    leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
    leaderboardController.gameCenterDelegate = self;
      [rnView presentViewController: leaderboardController animated: YES completion:nil];
    resolve(@"opened Leaderboard");
  }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)viewController
{
   NSLog(@"DISSSMMIIISSSSSEDDDD1");
  [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)gameCenterViewControllerDidCancel:(GKGameCenterViewController *)gameCenterViewController
{
    NSLog(@"DISSSMMIIISSSSSEDDDD3");
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [gkView dismissViewControllerAnimated:YES completion:^{
////      self.callback(@[@{@"didCancel": @YES}]);
//    }];
//  });
}


RCT_EXPORT_METHOD(showAchievements: (RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject){


  GKGameCenterViewController* gcViewController = [[GKGameCenterViewController alloc]init];

  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
  gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
  [rnView presentViewController:gcViewController animated:YES completion:nil];
  //  }
  resolve(@"opened");
};









RCT_EXPORT_METHOD(reportScore:(NSDictionary *)options

                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  //GKGameCenterViewController* gcViewController = [[GKLeaderboardViewController alloc]init];
//  GKScore *gkscore;
//  if(options[@"leaderboardIdentifier"]){
//      gkscore = [[GKScore alloc] initWithLeaderboardIdentifier:options[@"leaderboardIdentifier"]];
//  }else{
//    gkscore = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
//  }

  //    int64_t intscore = score;
//  NSNumber* userScore = [options valueForKey:@"score"];
//  int score = [userScore intValue];

//
// int64_t score = options[@"score"];
//  int scoreInt = options[@"score"];
//  RCTLog(@"user score %@", score);
//  RCTLog(@"user scoreInt %@", scoreInt);
//
//  GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
//  score.value = options[@"score"];
//
//  [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
//    if (error != nil) {
//      NSLog(@"%@", [error localizedDescription]);
//    }
//  }];
  NSNumber *scoreInt4 = options[@"score"];
  //int64_t scoreInt = options[@"score"];
  //  NSNumber* userScore = [options valueForKey:@"score"];
    int scoreInt = [scoreInt4 intValue];
  NSString *leaderboardId;
  if(options[@"leaderboardIdentifier"]){
    leaderboardId=options[@"leaderboardIdentifier"];
  }else{
    leaderboardId=_leaderboardIdentifier;
  }

    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
    score.value = 20;

    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
      if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        reject(@"Error", @"Error reporting Score",error);
      }else{
        resolve(@"reported Score");
      }
    }];

};//RCT_EXPORT_METHOD




//- (void) getAchievements:(CDVInvokedUrlCommand*)command;
//RCT_EXPORT_METHOD(getAchievements:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve
  RCT_EXPORT_METHOD(getAchievements: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
//  __block CDVPluginResult* pluginResult = nil;
  NSMutableArray *earntAchievements = [NSMutableArray array];

  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
   {
     if (error == nil)
     {
       for (GKAchievement* achievement in achievements)
       {
         NSMutableDictionary *entry = [NSMutableDictionary dictionary];
         entry[@"identifier"] = achievement.identifier;
         entry[@"percentComplete"] = [NSNumber numberWithDouble: achievement.percentComplete];
         entry[@"completed"] = [NSNumber numberWithBool:achievement.completed];
         entry[@"lastReportedDate"] = [NSNumber numberWithDouble:[achievement.lastReportedDate timeIntervalSince1970] * 1000];
         entry[@"showsCompletionBanner"] = [NSNumber numberWithBool:achievement.showsCompletionBanner];
//         entry[@"playerID"] = achievement.playerID;
          NSLog(@"IDDDDD %@", achievement);
         [earntAchievements addObject:entry];
       }
       resolve(earntAchievements);
       //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray: earntAchievements];
     }else{
        reject(@"Error", @"Error getting achivements",error);
//       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
     }
//     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
   }];
}




RCT_EXPORT_METHOD(resetAchievements:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  // Clear all progress saved on Game Center.
  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
   {
     if (error != nil)
     {
           reject(@"Error", @"Error getting achivements",error);
     } else {

       resolve(@"reset Achievements");
     };

   }
   ];

}
RCT_EXPORT_METHOD(submitScore:(NSDictionary *)options

                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  int64_t scoreInt = options[@"score"];
//   int scoreInt = options[@"score"];
//    RCTLog(@"user score %@", score);
   RCTLog(@"user scoreInt %@", scoreInt);
//  NSNumber* userScore = [options valueForKey:@"score"];
//  int score = [userScore intValue];
  NSString *leaderboardId;
  if(options[@"leaderboardIdentifier"]){
    leaderboardId=options[@"leaderboardIdentifier"];
  }else{
    leaderboardId=_leaderboardIdentifier;
  }


  // Different methods depending on iOS version
//  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
    GKScore *scoreSubmitter = [[GKScore alloc] initWithLeaderboardIdentifier: leaderboardId];
  scoreSubmitter.value = scoreInt;
    scoreSubmitter.context = 0;

    [GKScore reportScores:@[scoreSubmitter] withCompletionHandler:^(NSError *error) {
      if (error)
      {
       reject(@"Error", @"Error submitting score",error);
      }else{
       resolve(@"successfully submited score");
      }
    }];

//  }else{
//    GKScore *scoreSubmitter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
//    scoreSubmitter.value = scoreInt;
//    [GKScore reportScores:@[scoreSubmitter] withCompletionHandler:^(NSError *error) {
//      if (error){
//         reject(@"Error", @"Error submitting score",error);
//      }else{
//        resolve(@"successfully submited score");
//      }
//    }];
//  }
}





  RCT_EXPORT_METHOD(reportAchievement:(NSDictionary *)options

                    resolve:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject){
//  NSMutableDictionary *args = [command.arguments objectAtIndex:0];
  NSString *achievementId = options[@"achievementId"];
  NSString *percent = options[@"percent"];

  float percentFloat = [percent floatValue];

//  __block CDVPluginResult* pluginResult = nil;

  GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: achievementId];
  if (achievement)
  {
    achievement.percentComplete = percentFloat;
    achievement.showsCompletionBanner = YES;

    NSArray *achievements = [NSArray arrayWithObjects:achievement, nil];

    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
      if (error != nil)
      {

        //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];

         reject(@"Error", @"Error reporting achievement",error);
      }
      else
      {
        // Achievement notification banners are broken on iOS 7 so we do it manually here if 100%:
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
            [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 &&
            floorf(percentFloat) >= 100)
        {
          [GKNotificationBanner showBannerWithTitle:@"Achievement" message:@"Completed!" completionHandler:^{}];
        }

//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        resolve(achievements);
      }
//      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
  }

}



//-(void)reportScore{
//  GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
//  score.value = _score;
//
//  [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
//    if (error != nil) {
//      NSLog(@"%@", [error localizedDescription]);
//    }
//  }];
//}



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
