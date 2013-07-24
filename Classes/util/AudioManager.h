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
#define SFX_BARK @"sfx_bark1.wav"

@interface AudioManager : NSObject

+(void)playbgm:(BGM_GROUP)tar;
+(void)playbgm_imm:(BGM_GROUP)tar;
+(void)playsfx:(NSString*)tar;

+(BGM_GROUP) get_cur_group;

+(void)set_play_bgm:(BOOL)t;
+(void)set_play_sfx:(BOOL)t;

+(void)transition_mode1;
+(void)transition_mode2;

@end
