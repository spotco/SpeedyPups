#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameEngineLayer.h"
#import "MainMenuLayer.h"
#import "DataStore.h"
#import "AudioManager.h"
#import "Common.h"
@class ChallengeInfo;

@interface GameMain : NSObject

+(void)main;
+(void)start_game_autolevel;
+(void)start_menu;
+(void)start_testlevel;
+(void)start_game_challengelevel:(ChallengeInfo*)info;

+(BOOL)GET_USE_BG;
+(BOOL)GET_DRAW_HITBOX;
+(BOOL)GET_HOLD_TO_STOP;

@end
