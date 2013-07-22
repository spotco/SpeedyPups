#import "GameMain.h"
#import "GameModeCallback.h" 

#import "UserInventory.h"
#import "Challenge.h"

@implementation GameMain

#define USE_BG YES
#define PLAY_SFX NO
#define PLAY_BGM NO
#define TESTLEVEL @"shittytest"
#define STARTING_LIVES 10

#define DRAW_HITBOX NO
#define RESET_STATS NO
#define DISPLAY_FPS NO

/**
 TODO
 -challenge mode finish anims (lots of fireworks)
 -reposition item use slot closer to edge
 -check day/night run music bug
 -sense of progress -- lab every once in a while, idea of 3 castles and final boss
 
 
 -infinite runner -- thrown in a lab group every 3 groups or so
 -infinite runner -- hardcode more level order into the game, remove a couple tutorials (swipedir),
  def show some "high quality" levels early on (trickytreas)
 
 -better continue and game over menu ui
 -text in tutorial
 
 -different dogs differnt special powers
	-corgi -- auto magnet stuff
	-pug -- higher jump
	-poodle -- slower fall speed
	-dalmation -- triple jump
	-husky -- longer duration dash
	-lab -- double dash (set cur_airjump_count to 2)
 - buy item sound + anim
 **/

/**
 Settings:
 -enable/disable sfx
 -enable/disable music
 -enable/disable tutorial levels
 -left/right/disable item slot
 -total bones collected
 -total deaths
 
 -infinite runner skip tutorial settings
 **/

/**
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
 double helicopter boss final challenge
 
 SFX:
 goal
 rocket
 armor
 1up
 boss sounds
 
 
 LAST BIT:
 credits, game end message, loop (after boss in infinite runner or double helicopter)
 
 
 - infinite runner - unlimited swipe mechanic
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
	//[UserInventory add_bones:1000];
	
	/*
	AutoLevelState *s = [AutoLevelState cons];
	for (int i = 0; i < 20; i++) {
		NSLog([s get_level]);
	}
	 */
	
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
	[CCDirectorDisplayLink set_framemodct:1];
    [[CCDirector sharedDirector] runningScene]?
    [[CCDirector sharedDirector] replaceScene:s]:
    [[CCDirector sharedDirector] runWithScene:s];
}

+(BOOL)GET_USE_BG {return USE_BG;}
+(BOOL)GET_DRAW_HITBOX {return DRAW_HITBOX;}
@end
