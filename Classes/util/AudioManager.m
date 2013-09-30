#import "AudioManager.h"
#import "ObjectAL.h"
#import "Common.h"

@implementation AudioManager

static ALChannelSource* channel;

static OALAudioTrack *bgm_1;
static OALAudioTrack *bgm_2;

static NSMutableDictionary *sfx_buffers;
static NSDictionary *bgm_groups;

static BOOL playsfx = YES;
static BOOL playbgm = YES;

+(void)initialize {
	ALDevice* device = [ALDevice deviceWithDeviceSpecifier:nil];
	ALContext* context = [ALContext contextOnDevice:device attributes:nil];
	[OpenALManager sharedInstance].currentContext = context;
	[OALAudioSession sharedInstance].handleInterruptions = YES;
	[OALAudioSession sharedInstance].allowIpod = NO;
	[OALAudioSession sharedInstance].honorSilentSwitch = YES;
	channel = [ALChannelSource channelWithSources:32];
	
	#define enumkey(x) [NSNumber numberWithInt:x]
	bgm_groups = @{
		enumkey(BGM_GROUP_WORLD1):@[
			BGMUSIC_GAMELOOP1,
			BGMUSIC_GAMELOOP1_NIGHT
		],
		enumkey(BGM_GROUP_LAB):@[
			BGMUSIC_LAB1
		],
		enumkey(BGM_GROUP_MENU):@[
			BGMUSIC_MENU1
		],
		enumkey(BGM_GROUP_BOSS1):@[
			BGMUSIC_BOSS1
		],
		enumkey(BGM_GROUP_JINGLE):@[
			BGMUSIC_JINGLE
		],
		enumkey(BGM_GROUP_WORLD2):@[
			BGMUSIC_GAMELOOP2
		],
		enumkey(BGM_GROUP_CAPEGAME):@[
			BGMUSIC_CAPEGAMELOOP
		]
	};
	
	#define BUFFERMAPGEN(x) x: [[OpenALManager sharedInstance] bufferFromFile:x]
	sfx_buffers = [[NSMutableDictionary alloc] init];
	[sfx_buffers addEntriesFromDictionary:@{
		BUFFERMAPGEN(SFX_BONE),
		BUFFERMAPGEN(SFX_BONE_2),
		BUFFERMAPGEN(SFX_BONE_3),
		BUFFERMAPGEN(SFX_BONE_4),
	 
		BUFFERMAPGEN(SFX_EXPLOSION),
		BUFFERMAPGEN(SFX_HIT),
		BUFFERMAPGEN(SFX_JUMP),
		BUFFERMAPGEN(SFX_SPIN),
		BUFFERMAPGEN(SFX_SPLASH),
		BUFFERMAPGEN(SFX_BIRD_FLY),
		BUFFERMAPGEN(SFX_ROCKBREAK),
		BUFFERMAPGEN(SFX_ELECTRIC),
		BUFFERMAPGEN(SFX_JUMPPAD),
		BUFFERMAPGEN(SFX_ROCKET_SPIN),
		BUFFERMAPGEN(SFX_SPEEDUP),
		BUFFERMAPGEN(SFX_BOP),
		BUFFERMAPGEN(SFX_CHECKPOINT),
		BUFFERMAPGEN(SFX_SWING),
		BUFFERMAPGEN(SFX_POWERUP),
		BUFFERMAPGEN(SFX_WHIMPER),
		BUFFERMAPGEN(SFX_ROCKET_LAUNCH),
		BUFFERMAPGEN(SFX_GOAL),
		BUFFERMAPGEN(SFX_ROCKET),
		BUFFERMAPGEN(SFX_SPIKEBREAK),
		BUFFERMAPGEN(SFX_BUY),
		BUFFERMAPGEN(SFX_1UP),
		BUFFERMAPGEN(SFX_BIG_EXPLOSION),
		BUFFERMAPGEN(SFX_FAIL),
	 
		BUFFERMAPGEN(SFX_BARK_LOW),
		BUFFERMAPGEN(SFX_BARK_MID),
		BUFFERMAPGEN(SFX_BARK_HIGH),
	 
		BUFFERMAPGEN(SFX_READY),
		BUFFERMAPGEN(SFX_GO),
	 
		BUFFERMAPGEN(SFX_BOSS_ENTER),
		BUFFERMAPGEN(SFX_COPTER_FLYBY),
	 
		BUFFERMAPGEN(SFX_MENU_DOWN),
		BUFFERMAPGEN(SFX_MENU_UP),
	 
		BUFFERMAPGEN(SFX_FANFARE_WIN),
		BUFFERMAPGEN(SFX_FANFARE_LOSE)
	 }];
	
	bgm_1 = [OALAudioTrack track];
	bgm_2 = [OALAudioTrack track];
	
	for (NSNumber *key in [bgm_groups keyEnumerator]) {
		NSArray *val = bgm_groups[key];
		if (val.count >= 1) [bgm_1 preloadFile:val[0]];
		if (val.count >= 2) [bgm_2 preloadFile:val[1]];
	}
	
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

+(void)set_play_bgm:(BOOL)t {
	playbgm = t;
	if (t == NO) {
		[bgm_1 stop];
		[bgm_2 stop];
	}
}

+(void)set_play_sfx:(BOOL)t {
	playsfx = t;
}

+(BOOL)get_play_bgm {
	return playbgm;
}

+(BOOL)get_play_sfx {
	return playsfx;
}

static BGM_GROUP curgroup;
static float bgm_1_gain_tar;
static float bgm_2_gain_tar;

static BGM_GROUP transition_target;
static int transition_ct;

+(BGM_GROUP) get_cur_group { return curgroup; }

+(void)playbgm:(BGM_GROUP)tar {
	if (playbgm == NO) return;
	if (curgroup == tar) return;
	
	curgroup = tar;
	
	if (![bgm_1 playing] && ![bgm_2 playing]) {
		[self playbgm_imm:tar];
	} else {
		transition_target = tar;
		transition_ct = 10;
	}
}

+(void)playbgm_imm:(BGM_GROUP)tar {
	if (playbgm == NO) return;
	
	[bgm_1 stop];
	[bgm_2 stop];
	
	curgroup = tar;
	bgm_1_gain_tar = 1;
	[bgm_1 setGain:bgm_1_gain_tar];
	bgm_2_gain_tar = 0;
	[bgm_2 setGain:bgm_2_gain_tar];
	
	NSArray *val = bgm_groups[enumkey(tar)];
	if (val.count >= 1) [bgm_1 playFile:val[0] loops:-1];
	if (val.count >= 2) [bgm_2 playFile:val[1] loops:-1];
}

+(void)transition_mode1 {
	NSArray *val = bgm_groups[enumkey(curgroup)];
	if (val.count >= 1) {
		bgm_1_gain_tar = 1;
		bgm_2_gain_tar = 0;
	} else {
		NSLog(@"bgm group %d does not have mode1",curgroup);
	}
	
}

+(void)transition_mode2 {
	NSArray *val = bgm_groups[enumkey(curgroup)];
	if (val.count >= 2) {
		bgm_1_gain_tar = 0;
		bgm_2_gain_tar = 1;
	} else {
		NSLog(@"bgm group %d does not have mode2",curgroup);
	}
}

+(void)playsfx:(NSString*)tar {
	if (playsfx == NO) return;
	if (sfx_buffers[tar]) [channel play:sfx_buffers[tar]];
}

static int mute_music_ct = 0;
static float sto_bgm1_gain = 0, sto_bgm2_gain = 0;
+(void)mute_music_for:(int)ct {
	mute_music_ct = ct;
	sto_bgm1_gain = [bgm_1 gain];
	sto_bgm2_gain = [bgm_2 gain];
}

+(void)update {
	if (mute_music_ct > 0) {
		mute_music_ct--;
		if (mute_music_ct > 0) {
			[bgm_1 setGain:0];
			[bgm_2 setGain:0];
		} else {
			[bgm_1 setGain:sto_bgm1_gain];
			[bgm_2 setGain:sto_bgm2_gain];
		}
	}
	
	if (transition_ct > 0) {
		float pct = ((float)transition_ct)/10.0f;
		if ([bgm_1 gain] != 0) {
			[bgm_1 setGain:pct];
		} else {
			if ([bgm_2 gain] != 0) {
				[bgm_2 setGain:pct];
			}
		}
		transition_ct--;
		if (transition_ct == 0) {
			[self playbgm_imm:transition_target];
		}
		
		
	} else {
		if (ABS([bgm_1 gain]-bgm_1_gain_tar) >= 0.01) {
			float sign = [Common sig:bgm_1_gain_tar-[bgm_1 gain]];
			[bgm_1 setGain:[bgm_1 gain] + sign*0.1];
		} else {
			[bgm_1 setGain:bgm_1_gain_tar];
		}
		
		if (ABS([bgm_2 gain]-bgm_2_gain_tar) >= 0.01) {
			float sign = [Common sig:bgm_2_gain_tar-[bgm_2 gain]];
			[bgm_2 setGain:[bgm_2 gain] + sign*0.1];
		} else {
			[bgm_2 setGain:bgm_2_gain_tar];
		}
		
	}
}

@end
