#import "ExtrasManager.h"
#import "DataStore.h" 
#import "Resource.h" 
#import "AudioManager.h" 
#import "ExtrasArtPopup.h"
#import "Common.h"
#import "FileCache.h"

@implementation ExtrasManager

static NSDictionary *names;
static NSDictionary *descs;

static NSArray *arts;
static NSArray *sfxs;
static NSArray *musics;

+(void)initialize {
	arts = @[
		EXTRAS_ART_GOOBER,
		EXTRAS_ART_MOEMOERUSH,
		EXTRAS_ART_PENGMAKU,
		EXTRAS_ART_WINDOWCLEANER
	];
	sfxs = @[
		SFX_FANFARE_WIN,
		SFX_FANFARE_LOSE,
		SFX_CHECKPOINT,
		SFX_WHIMPER,
		SFX_BARK_LOW,
		SFX_BARK_MID,
		SFX_BARK_HIGH,
		SFX_BOSS_ENTER,
		SFX_CAT_LAUGH,
		SFX_CAT_HIT,
		SFX_CHEER
	];
	musics = @[
		BGMUSIC_MENU1,
		BGMUSIC_INTRO,
		BGMUSIC_GAMELOOP1,
		BGMUSIC_GAMELOOP1_NIGHT,
		BGMUSIC_LAB1,
		BGMUSIC_BOSS1,
		BGMUSIC_CAPEGAMELOOP,
		BGMUSIC_JINGLE,
		BGMUSIC_GAMELOOP2,
		BGMUSIC_GAMELOOP2_NIGHT,
		BGMUSIC_GAMELOOP3,
		BGMUSIC_GAMELOOP3_NIGHT,
		BGMUSIC_INVINCIBLE
	];
	
	names = @{
		EXTRAS_ART_GOOBER: @"Jump, Goober, Jump!",
		EXTRAS_ART_MOEMOERUSH: @"MoeMoeRush!!",
		EXTRAS_ART_PENGMAKU: @"Manaic Pengmaku!",
		EXTRAS_ART_WINDOWCLEANER: @"Window Cleaner",
		
		SFX_FANFARE_WIN: @"Fanfare Win",
		SFX_FANFARE_LOSE: @"Fanfare Lose",
		SFX_CHECKPOINT: @"Checkpoint",
		SFX_WHIMPER: @"Dog Whimper",
		SFX_BARK_LOW: @"Low Bark",
		SFX_BARK_MID: @"Mid Bark",
		SFX_BARK_HIGH: @"High Bark",
		SFX_BOSS_ENTER: @"Boss Enter",
		SFX_CAT_LAUGH: @"Cat Laugh",
		SFX_CAT_HIT: @"Cat Hit",
		SFX_CHEER: @"Cheer",
		
		BGMUSIC_MENU1: @"Menu BGM",
		BGMUSIC_INTRO: @"Intro BGM",
		BGMUSIC_GAMELOOP1: @"World 1 Day BGM",
		BGMUSIC_GAMELOOP1_NIGHT: @"World 1 Night BGM",
		BGMUSIC_LAB1: @"Lab BGM",
		BGMUSIC_BOSS1: @"Boss BGM",
		BGMUSIC_CAPEGAMELOOP: @"Sky World BGM",
		BGMUSIC_JINGLE: @"Game Over Jingle",
		BGMUSIC_GAMELOOP2: @"World 2 Day BGM",
		BGMUSIC_GAMELOOP2_NIGHT: @"World 2 Night BGM",
		BGMUSIC_GAMELOOP3: @"World 3 Day BGM",
		BGMUSIC_GAMELOOP3_NIGHT: @"World 3 Night BGM",
		BGMUSIC_INVINCIBLE: @"Invincible Jingle"
	};
	
	descs = @{
		EXTRAS_ART_GOOBER: @"SPOTCO's first published game. Play online in a browser!",
		EXTRAS_ART_MOEMOERUSH: @"Made by SPOTCO in 24 hours with a few friends.",
		EXTRAS_ART_PENGMAKU: @"Made by SPOTCO for Ludum Dare 48.",
		EXTRAS_ART_WINDOWCLEANER: @"Made by SPOTCO with a few friends for CyberPunk Jam 2014.",
		
		SFX_FANFARE_WIN: @"Fanfare that plays on success.",
		SFX_FANFARE_LOSE: @"Fanfare that plays on failure.",
		SFX_CHECKPOINT: @"Checkpoint sound.",
		SFX_WHIMPER: @"Dog whimpering sound",
		SFX_BARK_LOW: @"Bark for Corgi, Poodle and Pug.",
		SFX_BARK_MID: @"Bark for Mutt and Dalmation.",
		SFX_BARK_HIGH: @"Bark for Husky and Lab.",
		SFX_BOSS_ENTER: @"Menacing boss enter cry, taken from Goober.",
		SFX_CAT_LAUGH: @"Evil cat laugh.",
		SFX_CAT_HIT: @"Cat gets hit!",
		SFX_CHEER: @"Cheers! Taken from Goober.",
		
		BGMUSIC_MENU1: @"Main menu music, by Joshua Kaplan.",
		BGMUSIC_INTRO: @"Music for intro cartoon, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP1: @"Music for world 1 daytime, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP1_NIGHT: @"Music for world 1 nighttime, by Joshua Kaplan.",
		BGMUSIC_LAB1: @"Music for labs, by Joshua Kaplan.",
		BGMUSIC_BOSS1: @"Music for boss battle, by Joshua Kaplan.",
		BGMUSIC_CAPEGAMELOOP: @"Music for cape minigame, by Joshua Kaplan.",
		BGMUSIC_JINGLE: @"Jingle that plays on game over, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP2: @"Music for world 2 daytime, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP2_NIGHT: @"Music for world 2 nighttime, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP3: @"Music for world 3 daytime, by Joshua Kaplan.",
		BGMUSIC_GAMELOOP3_NIGHT: @"Music for world 3 nighttime, by Joshua Kaplan.",
		BGMUSIC_INVINCIBLE: @"Jingle that plays on invincible, by Joshua Kaplan."
	};
}

+(Extras_Type)type_for_key:(NSString*)key {
	if ([arts containsObject:key]) {
		return Extras_Type_ART;
	} else if ([musics containsObject:key]) {
		return Extras_Type_MUSIC;
	} else {
		return Extras_Type_SFX;
	}
}

+(TexRect*)texrect_for_type:(Extras_Type)type {
	return [TexRect cons_tex:[Resource get_tex:TEX_NMENU_ITEMS]
						rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:
							  type == Extras_Type_ART?  @"extrasicon_art":
							  type == Extras_Type_MUSIC?  @"extrasicon_music":
							  @"extrasicon_sfx"]];
}

+(NSString*)name_for_key:(NSString*)key {
	NSString *rtv = [names objectForKey:key];
	return rtv ? rtv : @"???";
}

+(NSString*)desc_for_key:(NSString*)key {
	NSString *rtv = [descs objectForKey:key];
	return rtv ? rtv : @"???";
}

+(BOOL)own_extra_for_key:(NSString*)key {
	return [DataStore get_int_for_key:key];
}

+(void)set_own_extra_for_key:(NSString*)key {
	[DataStore set_key:key int_value:1];
}

+(NSMutableArray*)all_extras {
	NSMutableArray *rtv = [NSMutableArray array];
	for (NSString *key in names.keyEnumerator) [rtv addObject:key];
	return rtv;
}

+(NSString*)random_unowned_extra {
	NSMutableArray *all_extras = [self all_extras];
	[all_extras shuffle];
	while ([all_extras count] > 0) {
		if (![self own_extra_for_key:all_extras.lastObject]) {
			return all_extras.lastObject;
		}
		[all_extras removeLastObject];
	}
	return NULL;
}
@end
