#import "GameObject.h"

@class SubBossBGObject;
@class FGWater;

typedef enum SubMode {
	SubMode_Intro,
	SubMode_ToRemove,
	SubMode_BGFireBombs,
	SubMode_BGFireMissiles,
	SubMode_FrontJumpAttack
} SubMode;

@interface SubBoss : GameObject {
	CCSprite *body;
	CCSprite *hatch;
	CCSprite *wake;
	
	SubBossBGObject __unsafe_unretained *bgobj;
	
	FGWater *fgwater;
	SubMode current_mode;
	float groundlevel;
}

+(SubBoss*)cons_with:(GameEngineLayer*)g;

+(void)cons_anims;
@end
