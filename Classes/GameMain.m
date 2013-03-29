#import "GameMain.h"

@implementation GameMain

#define USE_BG NO
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"classic_tomslvl1"
#define STARTING_LIVES 99

#define ENABLE_BG_PARTICLES YES
#define DRAW_HITBOX NO
#define TARGET_FPS 60
#define RESET_STATS NO
#define DISPLAY_FPS NO
#define DEBUG_UI NO
#define USE_NSTIMER NO
#define HOLD_TO_STOP NO
/**
 levels to make:
 5 easy levels
 3 swingvine levels
 6 filler levels
 3 classic levels
 8 hard levels
 4 lab levels
 boss level
 **/

/**
 TODO --
 -100 bones = 1up
 -new pause menu
 -new death menu
 
 -secret/25bones item
 -char select make work,sit anim for all dogs, fix shadows
 -different dogs differnt special powers
    ideas: higher jump, more float power, longer dash, faster, auto item magnet
 -challenge mode with gameend anim
 -boss1 sfx, breakage particles, nozzle fire, boss explode particles
 -menu to game day/night transition
 **/

/**
 Settings:
 -enable/disable sfx
 -enable/disable music
 -enable/disable tutorial levels
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
 **/

/**
 Challenges:
 -beat classic_trickytreas with 28 or more bones
 -beat easy_gottagofast with 60 or more bones
 -get all bones in tutorial_breakrocks
 -get most bones in tutorial_swingvine
 -get all bones in tutorial_swipeget
 
 -beat swingvine_bounswindodg in 0:20 or less
 -beat tutorial_spikevine in 0:20 or less
 
 -find secret in tutorial_spikes
 -find secret in jumppad_crazyloop
 -find secret in jumppad_jumpislands
 -find secret in jumppad_spikeceil
 -find secret in easy_world1
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
    
    //[GameMain start_testlevel];
    //[GameMain start_game_autolevel];
    [GameMain start_menu];
    
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
+(BOOL)GET_ENABLE_BG_PARTICLES {return ENABLE_BG_PARTICLES;}
+(BOOL)GET_DRAW_HITBOX {return DRAW_HITBOX;}
+(float)GET_TARGET_FPS {return 1.0/TARGET_FPS;}
+(BOOL)GET_USE_NSTIMER {return USE_NSTIMER;}
+(BOOL)GET_HOLD_TO_STOP {return HOLD_TO_STOP;}
+(BOOL)GET_DEBUG_UI {return DEBUG_UI;}
@end
