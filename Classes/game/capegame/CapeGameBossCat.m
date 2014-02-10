#import "CapeGameBossCat.h"
#import "Resource.h"
#import "FileCache.h"
#import "RobotBossComponents.h"
#import "CapeGameBossBomb.h"

@implementation CapeGameBossCat

+(CapeGameBossCat*)cons {
	return [CapeGameBossCat node];
}

#define LERP_TO(pos1,pos2,div) ccp(pos1.x+(pos2.x-pos1.x)/div,pos1.y+(pos2.y-pos1.y)/div)
#define DEFAULT_X_PCT 0.8
#define DEFAULT_POS [Common screen_pctwid:DEFAULT_X_PCT pcthei:0.5]
-(id)init {
	self = [super init];
	
	cat_body = [CatBossBody cons];
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
		}
		
	} else if (mode == CapeGameBossCatMode_TAUNT) {
		delay_ct -= [Common get_dt_Scale];
		if (delay_ct <= 0) {
			mode = CapeGameBossCatMode_PATTERN_1;
			[cat_body stand_anim];
			cat_screen_pos = ccp(DEFAULT_X_PCT,0.5);
			pts_itr = 0;
			delay_ct = 0;
		}
		
	} else if (mode == CapeGameBossCatMode_PATTERN_1) {
		if (delay_ct > 0 && delay_ct - [Common get_dt_Scale] <= 0) {
			[g add_gameobject:[CapeGameBossBomb cons_pos:cat_body.position]];
		}
		
		delay_ct -= [Common get_dt_Scale];
		
		if (delay_ct <= 0) {
			CGPoint pts[] = {ccp(DEFAULT_X_PCT,0.2), ccp(DEFAULT_X_PCT,0.5), ccp(DEFAULT_X_PCT,0.8), ccp(DEFAULT_X_PCT,0.5)};
			int pts_len = 4;
			
			CGPoint tar_pt = pts[pts_itr];
			cat_screen_pos = LERP_TO(cat_screen_pos, tar_pt, 30.0);
			[cat_body setPosition:[Common screen_pctwid:cat_screen_pos.x pcthei:cat_screen_pos.y]];
			if (CGPointDist(cat_body.position, [Common screen_pctwid:tar_pt.x pcthei:tar_pt.y]) < 5) {
				pts_itr = (pts_itr+1)%pts_len;
				delay_ct = 30;
			}
		}
	}
	
}

-(void)setPosition:(CGPoint)position{}

@end
