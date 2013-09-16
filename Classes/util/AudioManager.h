#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

typedef enum {
	BGM_GROUP_WORLD1 = 0,
	BGM_GROUP_LAB = 1,
	BGM_GROUP_MENU = 2,
	BGM_GROUP_BOSS1 = 3,
	BGM_GROUP_JINGLE = 4
} BGM_GROUP;

//bgm_1
#define BGMUSIC_MENU1 @"menu1.aiff"
#define BGMUSIC_GAMELOOP1 @"gameloop1.aiff"
#define BGMUSIC_BOSS1 @"boss1.aiff"
#define BGMUSIC_LAB1 @"lab1.aiff"
#define BGMUSIC_JINGLE @"jingle.aiff"

//bgm_2
#define BGMUSIC_GAMELOOP1_NIGHT @"gameloop1_night.aiff"

#define SFX_BONE @"sfx_bone.wav"
#define SFX_EXPLOSION @"sfx_explosion.wav" 
#define SFX_HIT @"sfx_hit.wav"
#define SFX_JUMP @"sfx_jump.wav"
#define SFX_SPIN @"sfx_spin.wav"
#define SFX_SPLASH @"sfx_splash.wav"
#define SFX_BIRD_FLY @"sfx_bird_fly.wav" 
#define SFX_ROCKBREAK @"sfx_rockbreak.wav"
#define SFX_ELECTRIC @"sfx_electric.wav"
#define SFX_JUMPPAD @"sfx_jumppad.wav"
#define SFX_ROCKET_SPIN @"sfx_rocket_spin.wav"
#define SFX_SPEEDUP @"sfx_speedup.wav"
#define SFX_BOP @"sfx_bop.wav"
#define SFX_CHECKPOINT @"sfx_checkpoint.wav" 
#define SFX_SWING @"sfx_swing.wav" 
#define SFX_POWERUP @"sfx_powerup.wav"
#define SFX_1UP @"sfx_1up.wav"
#define SFX_BIG_EXPLOSION @"sfx_big_explosion.wav"
#define SFX_FAIL @"sfx_fail.wav"

#define SFX_WHIMPER @"sfx_whimper.wav"
#define SFX_ROCKET_LAUNCH @"sfx_rocket_launch.wav"
#define SFX_GOAL @"sfx_goal.wav"
#define SFX_ROCKET @"sfx_rocket.wav"
#define SFX_SPIKEBREAK @"sfx_spikebreak.wav"
#define SFX_BUY @"sfx_buy.wav"

#define SFX_BARK_LOW @"bark_low.wav"
#define SFX_BARK_MID @"bark_mid.wav"
#define SFX_BARK_HIGH @"bark_high.wav"

#define SFX_READY @"sfx_ready.wav"
#define SFX_GO @"sfx_go.wav"

#define SFX_COPTER_FLYBY @"sfx_copter_flyby.wav"

#define SFX_MENU_UP @"sfx_menu_up.wav" 
#define SFX_MENU_DOWN @"sfx_menu_down.wav"

#define SFX_FANFARE_WIN @"fanfare_win.aiff"
#define SFX_FANFARE_LOSE @"fanfare_lose.aiff"


@interface AudioManager : NSObject

+(void)playbgm:(BGM_GROUP)tar;
+(void)playbgm_imm:(BGM_GROUP)tar;
+(void)playsfx:(NSString*)tar;

+(BGM_GROUP) get_cur_group;

+(void)set_play_bgm:(BOOL)t;
+(void)set_play_sfx:(BOOL)t;

+(void)transition_mode1;
+(void)transition_mode2;

+(void)mute_music_for:(int)ct;

@end
