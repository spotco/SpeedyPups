#import "CapeGameEngineLayer.h"
@class CatBossBody;

typedef enum CapeGameBossCatMode {
	CapeGameBossCatMode_INITIAL_IN,
	CapeGameBossCatMode_TAUNT,
	CapeGameBossCatMode_PATTERN_1
	
} CapeGameBossCatMode;

@interface CapeGameBossCat : CapeGameObject {
	CatBossBody *cat_body;
	float delay_ct;
	CapeGameBossCatMode mode;
	
	CGPoint cat_screen_pos;
	int pts_itr;
}

+(CapeGameBossCat*)cons;

@end
