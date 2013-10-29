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
	
	CCAction* _current_anim;
	
	SubBossBGObject __unsafe_unretained *bgobj;
	
	FGWater *fgwater;
	SubMode current_mode;
	float groundlevel;
	
	int ct;
	int sub_submode;
	float flt_ct;
	CGPoint body_rel_pos;
}

+(SubBoss*)cons_with:(GameEngineLayer*)g;

+(void)cons_anims;
@end
