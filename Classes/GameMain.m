#import "GameMain.h"

#import "UserInventory.h"
#import "Challenge.h"

@implementation GameMain

#define USE_BG NO
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"shittytest"
#define STARTING_LIVES 1

#define DRAW_HITBOX NO
#define RESET_STATS YES
#define DISPLAY_FPS NO
#define HOLD_TO_STOP NO
/**
 levels to make:
 1 upsidedown tutorial
 5 easy levels
 3 swingvine levels
 4 filler levels
 3 classic levels
 8 hard levels
 4 lab levels
 boss level
 **/

/**
 TODO --
 -100 bones = 1up
 -new death menu
 
 -secret/25bones item
 -different dogs differnt special powers
    ideas: higher jump, more float power, longer dash, faster, auto item magnet
 -challenge mode with gameend anim
 -boss1 sfx, breakage particles, nozzle fire, boss explode particles
 -menu to game day/night transition
 -fix shadows for husky and armored dog
 **/

/**
 Settings:
 -enable/disable sfx
 -enable/disable music
 -enable/disable tutorial levels
 -left/right/disable item slot
 -total bones collected
 -total deaths
 **/

/**
 Shop:
 -Unlock everything $0.99
 -Unlock dogs (1000,3000,6000,10000,150000,20000)
 -Unlock concept art (500,1000,1500,2000 bones)
 -Unlock debug menu 10000
 -items (single use):
    Rocket (shoot forward) 100
    Magnet (get bones) 200
    Shield (temp invul) 300
    Heart (extra health) 400
 -upgrades more slots
 **/

+(void)main {
    [GEventDispatcher lazy_alloc];
    [DataStore cons];
    [AudioManager cons];
    [AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
    [Resource cons_textures];
    [BatchDraw cons];

    if (RESET_STATS) [DataStore reset_all];
    [[CCDirector sharedDirector] setDisplayFPS:DISPLAY_FPS];
    
    [UserInventory unlock_slot];
    [UserInventory unlock_slot];
    [UserInventory unlock_slot];
    
    
    [UserInventory set_inventory_ct_of:Item_Magnet to:20];
    [UserInventory set_inventory_ct_of:Item_Rocket to:20];
    [UserInventory set_inventory_ct_of:Item_Shield to:20];
    [UserInventory set_inventory_ct_of:Item_Heart to:20];
    
    
    [UserInventory set_item:Item_Heart to_slot:0];
    [UserInventory set_item:Item_Rocket to_slot:1];
    [UserInventory set_item:Item_Magnet to_slot:2];
    [UserInventory set_item:Item_Shield to_slot:3];
    
    [ChallengeRecord set_beaten_challenge:0 to:YES];
    [ChallengeRecord set_beaten_challenge:1 to:YES];
    
    //[GameMain start_testlevel];
    [GameMain start_game_autolevel];
    //[GameMain start_menu];
    
}

+(void)start_game_autolevel {
    [GameMain run_scene:[GameEngineLayer scene_with_autolevel_lives:STARTING_LIVES]];
}
+(void)start_menu {
    [GameMain run_scene:[MainMenuLayer scene]];
}
+(void)start_testlevel {
    [GameMain run_scene:[GameEngineLayer scene_with:TESTLEVEL lives:GAMEENGINE_INF_LIVES]];
}
+(void)run_scene:(CCScene*)s {
    [[CCDirector sharedDirector] runningScene]?
    [[CCDirector sharedDirector] replaceScene:s]:
    [[CCDirector sharedDirector] runWithScene:s];
}

+(BOOL)GET_USE_BG {return USE_BG;}
+(BOOL)GET_DRAW_HITBOX {return DRAW_HITBOX;}
+(BOOL)GET_HOLD_TO_STOP {return HOLD_TO_STOP;}
@end
