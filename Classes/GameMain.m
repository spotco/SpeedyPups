#import "GameMain.h"
#import "GameModeCallback.h" 
#import "FreePupsAnim.h"

#import "UserInventory.h"
#import "Challenge.h"
#import "FreeRunStartAtManager.h"
#import "LoadingScene.h"
#import "IntroAnim.h"

#import "WebRequest.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX YES
#define PLAY_BGM NO
#define TESTLEVEL @"shittytest"

#define RESET_STATS NO
#define STARTING_LIVES 10
#define SET_CONSTANT_DT NO
#define DRAW_HITBOX NO

/**
 labfiller is fucked
 launcherrobot sound cooldown (manyrockets lab level)
 subboss on reset remove fgwater
 dog/tutorialdog better shadow
 freepups fadein/out
 
 
 credits-interactive
 integrate new map assets, freerun progress popup redesign (prev, current, next)
 score ui
 add second currency and separate upgrade/unlock for items
 rare appearance levels by @2 or @3 in autolevelstate (fix weightedsorter)
 second currency tradein from bones daily
 more challenges (more secrets, cape game, boss rush)
 new look for upgrade pane
 facebook integration (like game on facebook, reward)
 ads integration, pay for no ads
 -art ask for:
	website
	video
 **/

/**
Stretch goals:
 3 lab levels
 3 more cannon levels
 10 more freerun levels
 make two spike levels into regular levels
 equipped item resetting in lab transition
 bug armor -> rocket -> end -> swingvine, still in rocket form
 random super reward level
 flip match-2 minigame (collect tokens ingame for tries)
 stats tracking
 implement challenge of the week
 goober pet
 levels based around armor (armor break spikes)
 store sales (streamed from online)
 object pool system
 
 art freerun start menu redesign + button
 pass cycle fillers (for harder/easier fillers)
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
	
	
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB1];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB2];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
	[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB3];
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL compress_textures = [defaults boolForKey:@"Compress Textures?"];
	if (compress_textures) {
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	} else {
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	}
	
	/*
	WorldStartAt startat;
	startat.world_num = WorldNum_3;
	startat.tutorial = NO;
	startat.bg_start = BGMode_LAB;
	AutoLevelState *state = [AutoLevelState cons_startat:startat];
	DO_FOR(40,
		   NSString *rtv = [state get_level];
		   if (streq(rtv,@"boss3_start")) {
			   [state to_boss_mode];
		   
		   } else if (streq(rtv, @"boss3_area")) {
			   [state to_labexit_mode];
		   }
		   NSLog(@"%d:\'%@\'",i,rtv)
	);
	*/
	
	/*
	[UserInventory unlock_character:TEX_DOG_RUN_2];
	[UserInventory unlock_character:TEX_DOG_RUN_3];
	[UserInventory unlock_character:TEX_DOG_RUN_4];
	[UserInventory unlock_character:TEX_DOG_RUN_5];
	[UserInventory unlock_character:TEX_DOG_RUN_6];
	[UserInventory unlock_character:TEX_DOG_RUN_7];
	*/
	
	//[UserInventory set_equipped_gameitem:Item_Shield];
	
	//[UserInventory add_bones:100000];
	 
	LoadingScene *loader = [LoadingScene cons];
	[self run_scene:loader];
	
	//to load the TESTLEVEL
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_testlevel)]];
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_game_autolevel)]];
	[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_introanim)]];
	//[loader load_with_callback:[Common cons_callback:(NSObject*)self sel:@selector(start_menu)]];
}

+(void)start_introanim {
	[GameMain run_scene:[IntroAnim scene]];
}

+(void)start_game_autolevel {
    [GameMain run_scene:[GameEngineLayer scene_with_autolevel_lives:STARTING_LIVES world:[FreeRunStartAtManager get_startingat]]];
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
