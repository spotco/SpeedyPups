#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameEngineLayer.h"
#import "MainMenuLayer.h"
#import "DataStore.h"
#import "AudioManager.h"
#import "Common.h"

@interface GameMain : NSObject

+(void)main;
+(void)start_game_autolevel;
+(void)start_menu;
+(void)start_testlevel;

+(BOOL)GET_USE_BG;
+(BOOL)GET_DRAW_HITBOX;
+(BOOL)GET_HOLD_TO_STOP;

@end
