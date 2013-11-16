#import "GameMain.h"
#import "GameModeCallback.h" 

#import "UserInventory.h"
#import "Challenge.h"
#import "FreeRunStartAtManager.h"
#import "LoadingScene.h"

#import "WebRequest.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX YES
#define PLAY_BGM YES
#define TESTLEVEL @"tutorial_cannons"

#define RESET_STATS NO
#define STARTING_LIVES 10
#define SET_CONSTANT_DT NO
#define DRAW_HITBOX NO

/**
 memory reduction
 fix rocket mechanics
 
 intro cartoon
 beat boss free pups cartoon scene
 
 sfx fireworks
 sfx tutorialdog float in/out
 
 cape game end big bone + applause
 cannon move track graphics
 
 some more secrets challenge level, loops jump through and long spike jump through (10 more challenges total)
 make 17 more levels
 
 -art ask for:
	cannon redesign
	freerun progress popup redesign
	freerun start menu redesign + button
	lab 3 + boss 3
	speedypups pro button + window
 **/

/**
Stretch goals:
 stats tracking
 make floatingwindow tabs classes
 implement level of the week
 integrate IAP speedypups subscription
 integrate ads
 
 goober pet
 levels based around armor (armor break spikes)
 challenges based around capegame
 store sales (streamed from online)
 **/

+(void)main {
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	
	[GEventDispatcher lazy_alloc];
    [DataStore cons];
    [BatchDraw cons];
	[AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
	 
	if (RESET_STATS) [DataStore reset_all];
	
	
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB2];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB3];
	
	/*
	[UserInventory unlock_character:TEX_DOG_RUN_2];
	[UserInventory unlock_character:TEX_DOG_RUN_3];
	[UserInventory unlock_character:TEX_DOG_RUN_4];
	[UserInventory unlock_character:TEX_DOG_RUN_5];
	[UserInventory unlock_character:TEX_DOG_RUN_6];
	[UserInventory unlock_character:TEX_DOG_RUN_7];
	*/
	 
	LoadingScene *loader = [LoadingScene cons];
	[self run_scene:loader];
	
	//to load the TESTLEVEL
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_testlevel)]];
	
	//to try the boss
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_game_autolevel)]];
	
	[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_menu)]];
	
	
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
