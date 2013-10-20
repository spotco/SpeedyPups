#import "GameObject.h"

@class SubBossBGObject;
@class FGWater;

typedef enum SubMode {
	SubMode_Intro,
	SubMode_ToRemove,
	SubMode_Attack1
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
