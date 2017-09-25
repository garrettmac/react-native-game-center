//
//  RNGameCenter.h
//  StockShot
//
//  Created by vyga on 9/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif




@interface RNGameCenter : NSObject <RCTBridgeModule>

@end
