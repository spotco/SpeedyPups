#import "AudioManager.h"

@implementation AudioManager

static const float FADE_SPD = 0.15;

static NSString* fade_target;
static BOOL initial_play = NO;

static BOOL play_bgm = YES;
static BOOL play_sfx = YES;

+(void)set_play_bgm:(BOOL)t {
    play_bgm = t;
    if (!play_bgm) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

+(void)set_play_sfx:(BOOL)t {
    play_sfx = t;
}

+(void)cons {
    NSArray *bgm = [NSArray arrayWithObjects:
        BGMUSIC_GAMELOOP1,
        BGMUSIC_MENU1,
    nil];
    
    for (NSString *i in bgm) {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:i];
    }
    
    NSArray *sfxs = [NSArray arrayWithObjects:
        SFX_BONE,
        SFX_EXPLOSION,
        SFX_HIT,
        SFX_JUMP,
        SFX_SPIN,
        SFX_SPLASH,
        SFX_BIRD_FLY,
        SFX_ROCKBREAK,
        SFX_ELECTRIC,
        SFX_JUMPPAD,
        SFX_ROCKET_SPIN,
        SFX_SPEEDUP,
        SFX_BOP,
        SFX_CHECKPOINT,
        SFX_SWING,
        SFX_BARK,
    nil];
    for (NSString* i in sfxs) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:i];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

+(void)play:(NSString *)tar {
    if (!play_bgm){
        return;
    }
    
    if (!initial_play) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:tar loop:YES];
        initial_play = YES;
        return;
    }
    
    fade_target = tar;
}

+(void)playsfx:(NSString*)tar {
    if (!play_sfx) {
        return;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:tar];
}

+(void)update {
    if (fade_target == NULL) {
        return;
    }
    
    float vol = [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
    if (vol >= FADE_SPD) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:vol-FADE_SPD];
    } else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fade_target loop:YES];
        fade_target = NULL;
    }
}

@end
