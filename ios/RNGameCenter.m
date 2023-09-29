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
#import <Foundation/Foundation.h>


//Global Defaults
NSString *_leaderboardIdentifier;
NSString *_achievementIdentifier;
NSString *_playerId;
BOOL _isGameCenterAvailable=NO;

static RNGameCenter *SharedInstance = nil;
//static NSString *scoresArchiveKey = @"Scores";
//static NSString *achievementsArchiveKey = @"Achievements";
//static BOOL isGameCenterAvailable()
//{
//  // Check for presence of GKLocalPlayer API.
//  Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
//
//  // The device must be running running iOS 4.1 or later.
//  NSString *reqSysVer = @"4.1";
//  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
//  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
//
//  return (gcClass && osVersionSupported);
//}

@interface RNGameCenter ()

@property (nonatomic, strong) GKGameCenterViewController *gkView;
@property (nonatomic, strong) UIViewController *reactNativeViewController;
@property (nonatomic, strong) NSNumber *_currentAdditionCounter;
@end

@interface MobSvcSavedGameData : NSObject
    @property (readwrite, retain) NSString *data;
    +(instancetype)sharedGameData;
    -(void)reset;
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
            _isGameCenterAvailable=YES;
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

RCT_EXPORT_METHOD(userLogged:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  resolve(_isGameCenterAvailable!=NO?@true:@false);
}

/* -----------------------------------------------------------------------------------------------------------------------------------------
 Player
 -----------------------------------------------------------------------------------------------------------------------------------------*/

/* --------------getPlayer--------------*/

RCT_EXPORT_METHOD(getPlayer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

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

/* --------------loadLeaderboardPlayers--------------
//let leaderboardIdentifier="high_scores"
// let achievementIdentifier="pro_award"
//let achievementIdentifier="novice_award"
RCT_EXPORT_METHOD(loadLeaderboardPlayers:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  NSArray *playersForIdentifiers=@[@"high_scores"];

  //  GKLocalPlayer *localPlayer =
  [GKLocalPlayer loadPlayersForIdentifiers:playersForIdentifiers withCompletionHandler:^(NSArray<GKPlayer *> * _Nullable players, NSError * _Nullable error) {
      NSLog(@"PLAYERRRS %@",players);
      if(error)return reject(@"Error",@"no users.", error);
        resolve(players);
    }];

}

*/


/* --------------getPlayerImage--------------*/
//

RCT_EXPORT_METHOD(getPlayerImage:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  @try{
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
      NSDictionary *json = @{@"image":path};
      resolve(json);
    }else{
      // Else load it from the game center
      [localPlayer loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (error!=nil)return reject(@"Error", @"Error fetching player image",error);

        if (photo != nil){
          NSData* data = UIImageJPEGRepresentation(photo, 0.8);
          [data writeToFile:path atomically:YES];
          NSDictionary *json = @{@"image":path};
          resolve(json);
        }else{
          NSMutableDictionary *json = [NSMutableDictionary dictionary];
          json[@"image"] = nil;
          resolve(json);
        }


      }];
    }
  }@catch (NSError * e) {
    reject(@"Error",@"Error fetching player image", e);
  }
}

//
//
//RCT_EXPORT_METHOD(challengePlayers:(NSDictionary *)options
//                  resolve:(RCTPromiseResolveBlock)resolve
//                  rejecter:(RCTPromiseRejectBlock)reject){
////- (void) challengeViewController:(MyAchievementChallengeViewController*)controller wasDismissedWithChallenge:(BOOL)issued
//  @try {
//    NSArray *challengePlayerArray=options[@"players"];
//    resolve(@"Successfully opened achievements");
//  }
//  @catch (NSError * e) {
//    reject(@"Error",@"Error opening achievements.", e);
//  }
////
////  [self dismissViewControllerAnimated:YES completion:NULL];
////  if (issued)
////  {
////
////  }
//}
//
//
//RCT_EXPORT_METHOD(challengeWithScore:(int64_t)playerScore
//                  options:(NSDictionary *)options
//                  resolve:(RCTPromiseResolveBlock)resolve
//                  rejecter:(RCTPromiseRejectBlock)reject){
////  -(void) sendScoreChallengeToPlayers:(NSArray*)players withScore:(int64_t)score message:(NSString*)message {
//  NSString *message = options[@"message"];
//  //NSArray *players = options[@"players"];
//  NSMutableArray *players=@[@"G:8135064222"];
//
//  NSString *achievementId;
//  if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
//    //1
//    GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:achievementId];
//    gkScore.value = playerScore;
//
//    //2
//   UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [gkScore issueChallengeToPlayers:players message:message];
//  GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
////    [rnView presentViewController: leaderboardController animated: YES completion:nil];
//
//  [rnView presentViewController:gkScore animated:YES completion:nil];
//
//  //challengeComposeControllerWithMessage
////  }
//
//}
//
//
////-(void) findScoresOfFriendsToChallenge {
//  RCT_EXPORT_METHOD(findScoresOfFriendsToChallenge:(NSDictionary *)options
//                    resolve:(RCTPromiseResolveBlock)resolve
//                    rejecter:(RCTPromiseRejectBlock)reject){
//
//    // Get leaderboardIdentifier or use default leaderboardIdentifier
//    NSString *achievementId;
//    if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
//    else achievementId=_achievementIdentifier;
//  GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];
//  leaderboard.identifier = achievementId;
//  leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
//  leaderboard.range = NSMakeRange(1, 100);
//  [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
//    BOOL success = (error == nil);
//
//    if (success) {
////      if (!_includeLocalPlayerScore) {
////        NSMutableArray *friendsScores = [NSMutableArray array];
////        for (GKScore *score in scores) {
////          if (![score.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
////            [friendsScores addObject:score];
////          }
////        }
////        scores = friendsScores;
//      resolve(scores);
//
//    }else{
//       reject(@"Error", @"Error scores",error);
//    }
//  }];
//}
//



/* -----------------------------------------------------------------------------------------------------------------------------------------
 Leaderboard
  -----------------------------------------------------------------------------------------------------------------------------------------*/

/* --------------openLeaderboardModal--------------*/
//RCT_EXPORT_METHOD(openLeaderboardModal:(NSString *)leaderboardIdentifier
RCT_EXPORT_METHOD(openLeaderboardModal:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  //RCT_EXPORT_METHOD(openLeaderboardModal:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

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

  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  @try{
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
  }@catch (NSError * e) {
    reject(@"Error",@"Error submitting score.", e);
  }
}



/* --------------getLeaderboardPlayers--------------*/

RCT_EXPORT_METHOD(getLeaderboardPlayers:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  @try{
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
  }@catch (NSError * e) {
    reject(@"Error",@"Error getting leaderboard players.", e);
  }
}



/*
 -----------------------------------------------------------------------------------------------------------------------------------------
 Achievements
 -----------------------------------------------------------------------------------------------------------------------------------------
*/

/* --------------openAchievementModal--------------*/

RCT_EXPORT_METHOD(openAchievementModal: (NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  @try {
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
    gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
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

  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  NSMutableArray *earntAchievements = [NSMutableArray array];
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error){
    if (error == nil) {
      for (GKAchievement* achievement in achievements) {
        NSMutableDictionary *entry = [NSMutableDictionary dictionary];
        entry[@"identifier"] = achievement.identifier;
        entry[@"percentComplete"] = [NSNumber numberWithDouble: achievement.percentComplete];
        entry[@"completed"] = [NSNumber numberWithBool:achievement.completed];
        entry[@"lastReportedDate"] = [NSNumber numberWithDouble:[achievement.lastReportedDate timeIntervalSince1970] * 1000];
        entry[@"showsCompletionBanner"] = [NSNumber numberWithBool:achievement.showsCompletionBanner];
        //  entry[@"playerID"] = achievement.playerID;
        [earntAchievements addObject:entry];
      }
      resolve(earntAchievements);
    }else{
      reject(@"Error", @"Error getting achievements",error);
    }
   }];
}



/* --------------resetAchievements--------------*/
RCT_EXPORT_METHOD(resetAchievements:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  // Clear all progress saved on Game Center.
  if(!options[@"hideAlert"]){
    UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Reset Achievements?"
                                 message:@"Are you sure you want to reset your achievements. This can not be undone."
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertController *yesAlert = [UIAlertController  alertControllerWithTitle:@"Success!"
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
                                  if(error != nil) {
                                    reject(@ "Error", @ "Error resetting achievements", error);}
                                  else {
                                    [rnView presentViewController:yesAlert animated:YES completion:nil];
                                    NSDictionary *json = @{
                                      @"message":@"User achievements not reset",
                                      @"resetAchievements":@true
                                    };
                                    resolve(json);
                                  }
                                }];
                              }];

  UIAlertAction* noButton = [UIAlertAction
                             actionWithTitle:@"No!"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                //Handle no, thanks button
                                NSDictionary *json = @{
                                  @"message":@"User achievements not reset",
                                  @"resetAchievements":@false
                                };
                                resolve(json);
                             }];

  [alert addAction:yesButton];
  [alert addAction:noButton];

  [rnView presentViewController:alert animated:YES completion:nil];

  }else{
    NSDictionary *json = @{
      @"message":@"User achievements reset",
      @"resetAchievements":@true
    };
    resolve(json);
  }

}


/* --------------submitAchievement--------------*/

RCT_EXPORT_METHOD(submitAchievementScore:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO) {
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }
  @try{
    NSString *percent = options[@"percentComplete"];

    float percentFloat = [percent floatValue];
    NSString *achievementId;
    if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
    else achievementId=_achievementIdentifier;

    RCTLog(@"Will store: %@ (%f) on '%@'", percent, percentFloat, achievementId);

    if(!achievementId)return reject(@"Error",@"No Game Center `achievementIdentifier` passed and no default set", nil);
    BOOL showsCompletionBanner=YES;
    if(options[@"hideCompletionBanner"])showsCompletionBanner=NO;
    NSLog(@"showsCompletionBanner %d",showsCompletionBanner);
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: achievementId];
    if (achievement){
      achievement.percentComplete = percentFloat;
      achievement.showsCompletionBanner = showsCompletionBanner;

      NSArray *achievements = [NSArray arrayWithObjects:achievement, nil];

      [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil){
          reject(@"Error",@"Game Center setting Achievement", error);
        }else{
          // Achievement notification banners are broken on iOS 7 so we do it manually here if 100%:
          if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
              [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 &&
              floorf(percentFloat) >= 100)
          {
            [GKNotificationBanner showBannerWithTitle:@"Achievement" message:@"Completed!" completionHandler:^{}];
          }
          resolve(achievements);
        }
      }];
    }
  } @catch (NSError * e) {
    reject(@"Error",@"Error setting achievement.", e);
  }
}


RCT_EXPORT_METHOD(invite:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  GKMatchRequest *request = [[GKMatchRequest alloc] init];
  request.minPlayers = 2;
  request.maxPlayers = 4;
  request.recipients =@[@"G:8135064222"];
  request.inviteMessage = @"Your Custom Invitation Message Here";
  request.recipientResponseHandler = ^(GKPlayer *player, GKInviteeResponse response) {
    resolve(player);
  };
}

RCT_EXPORT_METHOD(getPlayerFriends:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO){
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }
  resolve([GKLocalPlayer localPlayer].friends);
}

/*
RCT_EXPORT_METHOD(challengeComposer:(int64_t) playerScore
                  options:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

    GKLeaderboard *query = [[GKLeaderboard alloc] init];
    // Get achievementIdentifier or use default achievementIdentifier
    NSString *leaderboardId;
    if(options[@"leaderboardIdentifier"])leaderboardId=options[@"leaderboardIdentifier"];
    else leaderboardId=_leaderboardIdentifier;

    query.identifier = leaderboardId;
    query.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    query.range = NSMakeRange(1,100);
    [query loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
      NSPredicate *filter = [NSPredicate predicateWithFormat:@"value < %qi",playerScore];
      NSArray *lesserScores = [scores filteredArrayUsingPredicate:filter];
//      UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
      // *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
//      [self presentChallengeWithPreselectedScores: lesserScores];
      GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
      gkScore.value = playerScore;
      NSString *message=@"hey fag, face off?";
      //NSArray *players=@[@"high_scores"];
      NSMutableArray *players=@[@"G:8135064222"];

//      [gkScore issueChallengeToPlayers:players message:message];
//      GKScore *gkScore = [[GKInvite alloc] initWithLeaderboardIdentifier:leaderboardId];

      [gkScore challengeComposeControllerWithMessage:message
                                           players:players
       //players:[GKLocalPlayer localPlayer].friends
                                   completionHandler:^(UIViewController * _Nonnull composeController, BOOL didIssueChallenge, NSArray<NSString *> * _Nullable sentPlayerIDs) {
        if (error) reject(@"Error", @"Error reporting achievement",error);
        else resolve(sentPlayerIDs);
      }];
      }];
 }*/
  // Get achievementIdentifier or use default achievementIdentifier
//  NSString *achievementId;
//
//  if(options[@"achievementIdentifier"])achievementId=options[@"achievementIdentifier"];
//  else achievementId=_achievementIdentifier;
//
//  NSString *message=@"hey fag, face off?";
//  NSArray *players=@[@"high_scores"];
//  [self abc:@"Yoop"]

//    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:@"MyGame.bossDefeated"];
//    achievement.percentComplete = 100.0;
//    achievement.showsCompletionBanner = NO;
//
//    [achievement reportAchievements: [NSArray arrayWithObjects:achievement, nil] WithCompletionHandler:NULL];
//    [self performSegueWithIdentifier:@"achievementChallenge" sender:achievement];
//

//  [GKChallenge loadReceivedChallengesWithCompletionHandler:^(NSArray<GKChallenge *> * _Nullable challenges, NSError * _Nullable error) {
//    <#code#>
//  }];
//  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  // *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
//  [UIViewController  challengeComposeControllerWithMessage:message players:players
//completionHandler:^(NSError *error) {
//  if (error) reject(@"Error", @"Error reporting achievement",error);
//  else  resolve(@"opened challengeComposer!");
//}];
//


//
//- (void )prepareForSegue:(UIStoryboardSegue *)segue sender:(id)dsender
//{
//  if ([segue.identifier isEqualToString:@"achievementChallenge"])
//  {
////    MyAchievementChallengeViewController* challengeVC = (MyAchievementChallengeViewController*) segue.destinationViewController;
////    UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
////    [challengeVC performSegueWithIdentifier:@"startPlaying" sender:self];
//    //challengeVC.delegate = self;
//    //challengeVC.achievement = (GKAchievement*) sender;
//  }
//}
//
//- (void) challengeViewController:(MyAchievementChallengeViewController*)controller wasDismissedWithChallenge:(BOOL)issued
//{
//  [self dismissViewControllerAnimated:YES completion:NULL];
//  if (issued)
//  {
//    [controller.achievement issueChallengeToPlayers:controller.players message:controller.message];
//  }
//}

RCT_EXPORT_METHOD(challengePlayersToCompleteAchievement:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  if(_isGameCenterAvailable==NO) {
    reject(@"Error",@"Game Center is Unavailable", nil);
    return;
  }

  GKAchievement *achievement;
  [achievement selectChallengeablePlayers:[GKLocalPlayer localPlayer].friends withCompletionHandler:^(NSArray *challengeablePlayers, NSError *error) {
    if (challengeablePlayers){
      resolve(challengeablePlayers);
    }
  }];
}


/* issued when the player completed a challenge sent by a friend

- (void)player:(GKPlayer *)player didCompleteChallenge:(GKChallenge *)challenge issuedByFriend:(GKPlayer *)friendPlayer{
  NSLog(@"Challenge %@ sent by %@ completed", challenge.description , friendPlayer.displayName);
}
// issued when a friend of the player completed a challenge sent by the player

- (void)player:(GKPlayer *)player issuedChallengeWasCompleted:(GKChallenge *)challenge byFriend:(GKPlayer *)friendPlayer{
   NSLog(@"Your friend %@ has successfully completed the %@ challenge", friendPlayer.displayName, challenge.description);
}

// issued when a player wants to play the challenge and has just started the game (from a notification)

- (void)player:(GKPlayer *)player wantsToPlayChallenge:(GKChallenge *)challenge{
  //[self performSegueWithIdentifier:@"startPlaying" sender:self];

  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  [rnView performSegueWithIdentifier:@"startPlaying" sender:self];
}

// issued when a player wants to play the challenge and is in the game (the game was running while the challenge was sent)


- (void)player:(GKPlayer *)player didReceiveChallenge:(GKChallenge *)challenge{

  NSString *friendMsg = [[NSString alloc] initWithFormat:@"Your friend %@ has invited you to a challenge: %@", player.displayName, challenge.message];
  UIAlertView *theChallenge = [[UIAlertView alloc] initWithTitle:@"Want to take the challenge?" message:friendMsg delegate:self cancelButtonTitle:@"Challenge accepted" otherButtonTitles:@"No", nil];

  [theChallenge show];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  //if (buttonIndex == 0)  [self performSegueWithIdentifier:@"startPlaying"sender:self];
  if (buttonIndex == 0) {
  UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
  [rnView performSegueWithIdentifier:@"startPlaying" sender:self];
  }
}
*/
//-(void) submitAchievementScore:(NSString*)identifier percentComplete:(float)percent
//{
//  if (isGameCenterAvailable == NO)
//    return;
//
//  GKAchievement* achievement = [self getAchievement:identifier];
//  if (percent > achievement.percentComplete)
//  {
//    NSLog(@"new achievement %@ reported", achievement.identifier);
//    achievement.percentComplete = percent;
//    [achievement reportAchievementWithCompletionHandler:^(NSError* error) {
//      if (achievement.isCompleted) {
//        [delegate onReportAchievement:(GKAchievement*)achievement];
//      }
//    }];
//
//    [self saveAchievements];
//  }
//}
//- (NSString*)getGameCenterSavePath{
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  return [NSString stringWithFormat:@"%@/GameCenterSave.txt",[paths objectAtIndex:0]];
//}
//
//
//- (void)saveAchievements:(GKAchievement *)achievement
//{
//  NSString *savePath = [self getGameCenterSavePath];
//
//  // If achievements already exist, append the new achievement.
//  NSMutableArray *achievements = [[NSMutableArray alloc] init];// autorelease];
//  NSMutableDictionary *dict;
//  if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
//    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];// autorelease];
//
//    NSData *data = [dict objectForKey:achievementsArchiveKey];
//    if(data) {
//      NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//      achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
//      [unarchiver finishDecoding];
//      //[unarchiver release];
//      [dict removeObjectForKey:achievementsArchiveKey]; // remove it so we can add it back again later
//    }
//  }else{
//    dict = [[NSMutableDictionary alloc] init];// autorelease];
//
//  }
//      NSLog(@"saveeee%@",dict);
//
//  [achievements addObject:achievement];
//
//  // The achievement has been added, now save the file again
//  NSMutableData *data = [NSMutableData data];
//  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//  [archiver encodeObject:achievements forKey:achievementsArchiveKey];
//  [archiver finishEncoding];
//  [dict setObject:data forKey:achievementsArchiveKey];
//  [dict writeToFile:savePath atomically:YES];
//  //[archiver release];
//}
//


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

RCT_EXPORT_METHOD(loadSavedGameData:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  GKLocalPlayer *mobSvcAccount = [GKLocalPlayer localPlayer];

  if(!mobSvcAccount.isAuthenticated){
      reject(@"Error",@"Can't load game: Game center is not initalized...", nil);
      return;
  }

  [mobSvcAccount fetchSavedGamesWithCompletionHandler:^(NSArray<GKSavedGame *> * _Nullable savedGames, NSError * _Nullable error) {

    if(error != nil) {
        NSLog(@"Failed to prepare saved game data: %@", error.description);
        reject(@"Error",@"Can't load game", nil);
    }

    GKSavedGame *savedGameToLoad = nil;
    for(GKSavedGame *savedGame in savedGames) {            NSLog(@"Successfully downloaded saved game data");
      if([savedGame.name isEqualToString:options[@"name"]]) {
        if (savedGameToLoad == nil || savedGameToLoad.modificationDate < savedGame.modificationDate) {
            savedGameToLoad = savedGame;
        }
      }
    }
    if(savedGameToLoad == nil) {
      resolve(@{
        @"isConflict": @false,
        @"data": @""
      });
      return;
    }
    [savedGameToLoad loadDataWithCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
      if(error == nil) {
        MobSvcSavedGameData *savedGameData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"Successfully downloaded saved game data");
        resolve(@{
          @"isConflict": @false,
          @"data": savedGameData.data
        });
      } else {
        NSLog(@"Failed to download saved game data: %@", error.description);
        reject(@"Error",@"Can't load game", nil);
      }
    }];
  }];
}


RCT_EXPORT_METHOD(uploadSavedGameData:(NSDictionary *)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
  GKLocalPlayer *mobSvcAccount = [GKLocalPlayer localPlayer];

  if(!mobSvcAccount.isAuthenticated) {
    reject(@"Error",@"Can't save game: Game center is not initalized...", nil);
    return;
  }
  MobSvcSavedGameData *savedGameData = [[MobSvcSavedGameData alloc] init];
  savedGameData.data = options[@"data"];
  [mobSvcAccount saveGameData:[NSKeyedArchiver archivedDataWithRootObject:savedGameData] withName:options[@"name"] completionHandler:^(GKSavedGame * _Nullable savedGame __unused, NSError * _Nullable error) {
    if(error == nil) {
      NSLog(@"Successfully uploaded saved game data");
      resolve(@"Saved game data");
    } else {
      NSLog(@"Failed to upload saved game data: %@", error.description);
      reject(@"Error",@"Can't save game", nil);
    }
  }];
}




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


@implementation MobSvcSavedGameData

#pragma mark MobSvcSavedGameData implementation

static NSString * const sgDataKey = @"data";

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (void)reset
{
    self.data = nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.data forKey: sgDataKey];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [self init];
    if (self) {
        self.data = [decoder decodeObjectForKey:sgDataKey];
    }
    return self;
}

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

 - (void)openLeaderboardModal:(CDVInvokedUrlCommand *)command {
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

 - (void)openAchievementModal:(CDVInvokedUrlCommand *)command {
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
