#import "CapeGameBossCat.h"
#import "Resource.h"
#import "FileCache.h"
#import "VolleyRobotBossComponents.h"
#import "CapeGameBossBomb.h"
#import "AudioManager.h"

@implementation CapeGameBossCat

+(CapeGameBossCat*)cons {
	return [CapeGameBossCat node];
}

#define LERP_TO(pos1,pos2,div) ccp(pos1.x+(pos2.x-pos1.x)/div,pos1.y+(pos2.y-pos1.y)/div)
#define DEFAULT_X_PCT 0.8
#define DEFAULT_POS [Common screen_pctwid:DEFAULT_X_PCT pcthei:0.5]
-(id)init {
	self = [super init];
	
	cat_body = [VolleyCatBossBody cons];
	[cat_body setPosition:[Common screen_pctwid:0.4 pcthei:1.5]];
	[cat_body setScaleX:-0.5];
	[cat_body setScaleY:0.5];
	[self addChild:cat_body];
	
	mode = CapeGameBossCatMode_INITIAL_IN;
	return self;
}

-(void)update:(CapeGameEngineLayer *)g {
	[cat_body update];
	
	if (mode == CapeGameBossCatMode_INITIAL_IN) {
		cat_body.position = LERP_TO(cat_body.position, DEFAULT_POS, 20.0);
		if (CGPointDist(cat_body.position, DEFAULT_POS) < 10) {
			mode = CapeGameBossCatMode_TAUNT;
			delay_ct = 60;
			[cat_body laugh_anim];
			[AudioManager playsfx:SFX_LAUGH];
		}
		
	} else if (mode == CapeGameBossCatMode_TAUNT) {
		delay_ct -= [Common get_dt_Scale];
		if (delay_ct <= 0) {
			mode = CapeGameBossCatMode_PATTERN_1;
			[cat_body stand_anim];
			cat_screen_pos = ccp(DEFAULT_X_PCT,0.5);
			delay_ct = 0;
			pos_theta = 0;
		}
		
	} else if (mode == CapeGameBossCatMode_PATTERN_1) {
		cat_screen_pos.y = sinf(pos_theta) * 0.35 + 0.5;
		pos_theta+=0.02*[Common get_dt_Scale];
		[cat_body setPosition:[Common screen_pctwid:cat_screen_pos.x pcthei:cat_screen_pos.y]];
		
		if (delay_ct <= 0) {
			if (![cat_body get_throw_in_progress]) {
				[cat_body throw_anim_force:YES];
				
			} else if ([cat_body get_throw_finished]) {
				bomb_count++;
				if (bomb_count%7==0) {
					[g add_gameobject:[CapeGameBossPowerupRocket cons_pos:cat_body.position]];
				} else {
					[g add_gameobject:[CapeGameBossBomb cons_pos:cat_body.position]];
				}
				
				delay_ct = float_random(5, 70);
				[cat_body stand_anim];
				
			}
			
		} else {
			delay_ct -= [Common get_dt_Scale];
		}
	}
	
}

-(void)setPosition:(CGPoint)position{}

@end
