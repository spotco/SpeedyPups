#import "AudioManager.h"

@implementation AudioManager

static ALuint cur_bgm;

+(void)initialize {
}

+(void)set_play_bgm:(BOOL)t {
}

+(void)set_play_sfx:(BOOL)t {
}

+(void)cons {
	/*
    NSArray *bgm = [NSArray arrayWithObjects:
        BGMUSIC_GAMELOOP1,
        BGMUSIC_MENU1,
		BGMUSIC_GAMELOOP1_NIGHT,
    nil];
    
    for (NSString *i in bgm) {
        [audioengine_a preloadEffect:i];
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
        [audioengine_a preloadEffect:i];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];*/
	CDSoundEngine *seng = [CDAudioManager sharedManager].soundEngine;
	[seng defineSourceGroups:@[@1,@31]];
	[CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
	[seng loadBuffer:1 filePath:@"gameloop1.aiff"];
	[seng loadBuffer:2 filePath:@"gameloop1_night.aiff"];
	ALuint bgm1 = [[CDAudioManager sharedManager].soundEngine playSound:1 sourceGroupId:0 pitch:1.0f pan:0.0f gain:0.2f loop:YES];
	ALuint bgm2 = [[CDAudioManager sharedManager].soundEngine playSound:2 sourceGroupId:1 pitch:1.0f pan:0.0f gain:1.0f loop:YES];
}

+(void)play:(NSString *)tar {
}

+(void)playsfx:(NSString*)tar {
}

+(void)update {
	//[[CDAudioManager sharedManager].soundEngine ]
}

@end
