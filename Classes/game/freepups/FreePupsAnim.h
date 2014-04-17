#import "cocos2d.h"
#import "FreeRunStartAtManager.h"

@class GameEngineLayer;
@class FreeRunStartAtUnlockUIAnimation;

typedef enum {
	FreePupsAnimMode_RUNIN,
	FreePupsAnimMode_ROLL,
	FreePupsAnimMode_BREAKANDFALL,
	FreePupsAnimMode_MENU
	//FreePupsAnimMode_FADEOUT
} FreePupsAnimMode;

@class CCSprite_WithVel;
@class FreePupsUIAnimation;

@interface FreePupsAnim : CCLayer {
	CCAction *run_anim, *roll_anim;
	CCSprite_WithVel *dog, *cage_base, *cage_bottom, *cage_top;
	FreePupsAnimMode mode;
	
	BOOL cage_on_ground;
	NSMutableArray *pups;
	
	FreePupsUIAnimation *uianim;
	
	
	FreeRunStartAtUnlockUIAnimation *worldunlock_anim;
	CCSprite *menu_ui;
	CCSprite *left_curtain,*right_curtain,*bg_curtain;
	CGPoint left_curtain_tpos,right_curtain_tpos,bg_curtain_tpos;
}

+(CCScene*)scene_with:(WorldNum)worldnum g:(GameEngineLayer*)g;

@end
