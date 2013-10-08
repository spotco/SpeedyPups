#import "GameMain.h"
#import "GameModeCallback.h" 

#import "UserInventory.h"
#import "Challenge.h"
#import "FreeRunStartAtManager.h"

#import "WebRequest.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"lab_muhfiller"
#define STARTING_LIVES 10

#define SET_CONSTANT_DT NO
#define DRAW_HITBOX NO
#define RESET_STATS NO
#define DISPLAY_FPS NO

/**
 animated loading screen
 worldselect arrow clickable
 make floatingwindow tabs classes
 boss restart not bgm_play_imm
 wait for sfx to complete in gameover before jingle
	
-purchases tab
 implement level of the week
 integrate IAP speedypups subscription
 integrate ads
 
 -art ask for:
	settings page -> map page navmenu icon and bg design
	new UNLOCK NOW button design
	new clock icon
	intro cartoon
	world 2 & 3 art, bosses 2 & 3
 **/

/**
Stretch goals:
 stats tracking
 
 goober pet
 levels based around armor (armor break spikes)
 challenges based around capegame
 look into batchsprite
 store sales (streamed from online)
 **/

+(void)main {
    [GEventDispatcher lazy_alloc];
    [DataStore cons];
    [AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
    [BatchDraw cons];
	
	//todo -- loadscreen this, this is slow
	//[Resource cons_textures];
	for (NSString* i in [AutoLevelState get_all_levels]) {
        [MapLoader precache_map:i];
    }

    if (RESET_STATS) [DataStore reset_all];
    [[CCDirector sharedDirector] setDisplayFPS:DISPLAY_FPS];
	
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB2];
	
	[GameMain start_testlevel];
	//[GameMain start_game_autolevel];
	//[GameMain start_menu];
}

+(void)start_game_autolevel {
    [GameMain run_scene:[GameEngineLayer scene_with_autolevel_lives:STARTING_LIVES world:[FreeRunStartAtManager worldnum_for_startingloc]]];
}

+(void)start_game_challengelevel:(ChallengeInfo *)info {
	[GameMain run_scene:[GameEngineLayer scene_with_challenge:info world:WorldNum_1]];
	
}

+(void)start_menu {
	[self run_scene:[MainMenuLayer scene]];
}

+(void)start_testlevel {
	[self run_scene:[GameEngineLayer scene_with:TESTLEVEL lives:GAMEENGINE_INF_LIVES world:WorldNum_1]];
}

+(void)start_from_callback:(GameModeCallback *)c {
    if (c.mode == GameMode_FREERUN) {
        [self start_game_autolevel];
        
    } else if (c.mode == GameMode_CHALLENGE) {
        [self start_game_challengelevel:[ChallengeRecord get_challenge_number:c.val]];
        
    }
}

+(void)run_scene:(CCScene*)s {
	[UserInventory reset_to_equipped_gameitem];
	[CCDirectorDisplayLink set_framemodct:1];
    [[CCDirector sharedDirector] runningScene]?
    [[CCDirector sharedDirector] replaceScene:s]:
    [[CCDirector sharedDirector] runWithScene:s];
}

+(BOOL)GET_USE_BG {return USE_BG;}
+(BOOL)GET_DRAW_HITBOX {return DRAW_HITBOX;}
+(BOOL)GET_DO_CONSTANT_DT { return SET_CONSTANT_DT; }
@end
