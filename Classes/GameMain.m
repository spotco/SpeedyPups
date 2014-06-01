#import "GameMain.h"
#import "GameModeCallback.h" 
#import "FreePupsAnim.h"

#import "UserInventory.h"
#import "Challenge.h"
#import "FreeRunStartAtManager.h"
#import "LoadingScene.h"
#import "IntroAnim.h"
#import "CapeGameEngineLayer.h"

#import "WebRequest.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX YES
#define PLAY_BGM NO
#define TESTLEVEL @"capegame_launcher"
#define VERSION_STRING @"SpeedyPups BETA - May 2014"

#define DEBUG_UI NO
#define IMMEDIATELY_BOSS NO
#define BOSS_1_HEALTH NO
#define RESET_STATS NO

#define STARTING_LIVES 10
//#define STARTING_LIVES 1

#define SET_CONSTANT_DT NO
#define DRAW_HITBOX NO


/**
 go through and fix challenges
 challenges reward with coins
 
 daily login confirmation with online server
 figure out tracking
 
 figure out in app purchases
 figure out ads
 
 more challenges (more secrets, cape game, boss rush)
 
 -art ask for:
	video revamp
	concept art
 **/

/**
Stretch goals:
 capegame coin at end
 capegame bone magnets
 
 BUGFIX: settings add watch intro anim again button
 BUGFIX: capegame combo notifications
 BUGFIX: billboard move down
 facebook integration (like game on facebook, reward)
 3 lab levels
 3 more cannon levels
 10 more freerun levels
 random super reward level
 flip match-2 minigame (collect tokens ingame for tries)
 implement challenge of the week, downloadable levels
 goober pet
 levels based around armor (armor break spikes)
 weekly store sales
 OPTIMIZATION: convert all CCLabelTTF to CCLabelTTF_Pooled
 ??BUG: armor -> rocket -> end -> swingvine, still in rocket form
 **/

+(void)main {
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	//[[CCDirector sharedDirector].openGLView setMultipleTouchEnabled:YES];
	[GEventDispatcher lazy_alloc];
    [DataStore cons];
    [BatchDraw cons];
	[AudioManager set_play_bgm:PLAY_BGM];
    [AudioManager set_play_sfx:PLAY_SFX];
	 
	if (RESET_STATS) [DataStore reset_all];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL compress_textures = [defaults boolForKey:@"Compress Textures?"];
	if (compress_textures || [Common force_compress_textures]) {
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	} else {
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	}
	
	/*
	for (int ii = 0; ii < 3; ii++) {
		WorldStartAt startat;
		startat.world_num = WorldNum_1;
		startat.tutorial = YES;
		startat.bg_start = BGMode_NORMAL;
		AutoLevelState *state = [AutoLevelState cons_startat:startat];
		DO_FOR(40,
			   NSString *rtv = [state get_level];
			   if (streq(rtv,@"boss1_start")) {
				   [state to_boss_mode];
			   
			   } else if (streq(rtv, @"boss3_area")) {
				   [state to_labexit_mode];
			   }
			   

			   if ([[NSBundle mainBundle] pathForResource:rtv ofType:@"map"] == NULL) {
				   NSLog(@"%@ ERROR MISSING FILE",rtv);
			   }
			   NSLog(@"%d:\'%@\'",i,rtv)
		);
	}
	*/
	
	/*
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB1];
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB2];
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
	 [FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB3];
	*/
	/*
	[UserInventory unlock_character:TEX_DOG_RUN_2];
	[UserInventory unlock_character:TEX_DOG_RUN_3];
	[UserInventory unlock_character:TEX_DOG_RUN_4];
	[UserInventory unlock_character:TEX_DOG_RUN_5];
	[UserInventory unlock_character:TEX_DOG_RUN_6];
	[UserInventory unlock_character:TEX_DOG_RUN_7];
	[ChallengeRecord set_beaten_challenge:19 to:YES];
	*/
	
	
	//[UserInventory set_equipped_gameitem:Item_Shield];
	//[UserInventory add_bones:5000];
	//[UserInventory add_coins:25];
	
	LoadingScene *loader = [LoadingScene cons];
	[self run_scene:loader];
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_testlevel)]];
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_game_autolevel)]];
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_introanim)]];
	[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_menu)]];
}

+(void)start_introanim {
	[GameMain run_scene:[IntroAnim scene]];
}

+(void)start_game_autolevel {
    [GameMain run_scene:[GameEngineLayer scene_with_autolevel_lives:[Player current_character_has_power:CharacterPower_DOUBLELIVES]?STARTING_LIVES*2:STARTING_LIVES
															  world:[FreeRunStartAtManager get_startingat]]];
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
+(BOOL)GET_IMMEDIATE_BOSS { return IMMEDIATELY_BOSS; }
+(BOOL)GET_BOSS_1_HEALTH { return BOSS_1_HEALTH; }
+(int)GET_DEFAULT_STARTING_LIVES { return STARTING_LIVES; }
+(NSString*)GET_VERSION_STRING { return VERSION_STRING; }
+(BOOL)GET_DEBUG_UI { return DEBUG_UI; }
@end
