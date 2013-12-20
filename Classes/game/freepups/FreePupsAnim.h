#import "cocos2d.h"
#import "GameWorldMode.h"

typedef enum {
	FreePupsAnimMode_RUNIN,
	FreePupsAnimMode_ROLL,
	FreePupsAnimMode_BREAKANDFALL
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
}

+(CCScene*)scene_with:(LabNum)labnum;

@end
