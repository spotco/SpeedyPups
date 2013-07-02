#import "GameMain.h"
#import "GameModeCallback.h" 

#import "UserInventory.h"
#import "Challenge.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"lab_alladat" 
#define STARTING_LIVES 10

#define DRAW_HITBOX NO
#define RESET_STATS NO
#define DISPLAY_FPS NO
#define HOLD_TO_STOP NO
/**
 levels to make:
 2 lab filler levels
 **/

/**
 TODO --
 -different dogs differnt special powers
    ideas: higher jump, more float power, longer dash, faster, auto item magnet
 -more challenge mode ui
 -boss1 sfx, breakage particles, nozzle fire, boss explode particles
 -fix shadows for husky and armored dog
 -SLOWDOWN powerup
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
 -Unlock art, sound test, debug menu
 
 lab exit buggy
 rocket speed buggy
 
 Challenge:
 collect all bones in swingvine_awesome (67)
 classic_nubcave secret
 easy_curvywater get all bones
 easy_hillvine get all secrets
 filler_genome get 57 bones
 classic_manyoptredux beat fast
 classic_totalmix get 54 bones
 labintro_tutoriallauncher get all bones
 lab_alladat speedrun
 
 SFX:
 goal
 rocket
 armor
 1up
 boss sounds
 **/

+(void)main {
    [GEventDispatcher lazy_alloc];
    [DataStore cons];
    [AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
    [Resource cons_textures];
    [BatchDraw cons];

    if (RESET_STATS) [DataStore reset_all];
    [[CCDirector sharedDirector] setDisplayFPS:DISPLAY_FPS];
    
	/*
    [UserInventory unlock_slot];
    [UserInventory unlock_slot];
    [UserInventory unlock_slot];
    
    
    [UserInventory set_inventory_ct_of:Item_Magnet to:0];
    [UserInventory set_inventory_ct_of:Item_Rocket to:0];
    [UserInventory set_inventory_ct_of:Item_Shield to:0];
    [UserInventory set_inventory_ct_of:Item_Heart to:0];
	
	[UserInventory add_bones:20000];
    
    
    [UserInventory set_item:Item_Heart to_slot:0];
    [UserInventory set_item:Item_Rocket to_slot:1];
    [UserInventory set_item:Item_Magnet to_slot:2];
    [UserInventory set_item:Item_Shield to_slot:3];
    */
    /*
    [ChallengeRecord set_beaten_challenge:0 to:YES];
    [ChallengeRecord set_beaten_challenge:1 to:YES];
    [ChallengeRecord set_beaten_challenge:2 to:YES];
    [ChallengeRecord set_beaten_challenge:3 to:YES];
    [ChallengeRecord set_beaten_challenge:4 to:YES];
    [ChallengeRecord set_beaten_challenge:5 to:YES];
    [ChallengeRecord set_beaten_challenge:6 to:YES];
    [ChallengeRecord set_beaten_challenge:7 to:YES];
    [ChallengeRecord set_beaten_challenge:8 to:YES];
    [ChallengeRecord set_beaten_challenge:9 to:YES];
     */
    //[UserInventory add_bones:0];
    
	[GameMain start_testlevel];
    //[GameMain start_game_autolevel];
    //[GameMain start_menu];
    
}

+(void)start_game_autolevel {
    [GameMain run_scene:[GameEngineLayer scene_with_autolevel_lives:STARTING_LIVES]];
}

+(void)start_game_challengelevel:(ChallengeInfo *)info {
    [GameMain run_scene:[GameEngineLayer scene_with_challenge:info]];
}

+(void)start_menu {
    [GameMain run_scene:[MainMenuLayer scene]];
}

+(void)start_testlevel {
    [GameMain run_scene:[GameEngineLayer scene_with:TESTLEVEL lives:GAMEENGINE_INF_LIVES]];
}

+(void)start_from_callback:(GameModeCallback *)c {
    if (c.mode == GameMode_FREERUN) {
        [self start_game_autolevel];
        
    } else if (c.mode == GameMode_CHALLENGE) {
        [self start_game_challengelevel:[ChallengeRecord get_challenge_number:c.val]];
        
    } else {
        NSLog(@"error");
    }
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
