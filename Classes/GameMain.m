#import "GameMain.h"
#import "GameModeCallback.h" 

#import "UserInventory.h"
#import "Challenge.h"
#import "FreeRunStartAtManager.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"shittytest"
#define STARTING_LIVES 10

#define SET_CONSTANT_DT NO
#define DRAW_HITBOX NO
#define RESET_STATS NO
#define DISPLAY_FPS NO

/**
 TODO
	only partially load textures (as opposed to loading all)
	challenge page images
 
 More Challenges:
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
	 buy item
	 barking
 
 -art ask for:
	settings page -> map page navmenu icon
	new UNLOCK NOW button design
 **/

/**
Stretch goals:
 2nd and 3rd reskin world
 2nd and 3rd boss
 cloud cape flying minigame
 integrate IAPs
 weekly levels (streamed from online)
 store sales (streamed from online)
 **/

+(void)main {
    [GEventDispatcher lazy_alloc];
    [DataStore cons];
    [AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
    [BatchDraw cons];
	
	//todo -- loadscreen this, this is slow
	[Resource cons_textures];
	for (NSString* i in [AutoLevelState get_all_levels]) {
        [MapLoader precache_map:i];
    }

    if (RESET_STATS) [DataStore reset_all];
    [[CCDirector sharedDirector] setDisplayFPS:DISPLAY_FPS];
	//[UserInventory add_bones:100000];
	//[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
	//[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
	//[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB3];
	
	//[GameMain start_testlevel];
	//[GameMain start_game_autolevel];
    [GameMain start_menu];
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
	[CCDirectorDisplayLink set_framemodct:1];
    [[CCDirector sharedDirector] runningScene]?
    [[CCDirector sharedDirector] replaceScene:s]:
    [[CCDirector sharedDirector] runWithScene:s];
}

+(BOOL)GET_USE_BG {return USE_BG;}
+(BOOL)GET_DRAW_HITBOX {return DRAW_HITBOX;}
+(BOOL)GET_DO_CONSTANT_DT { return SET_CONSTANT_DT; }
@end
