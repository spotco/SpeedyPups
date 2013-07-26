#import "UIIngameAnimation.h"
#import "ChallengeInfoTitleCardAnimation.h"

typedef enum {
	FreeRunProgress_PRE_1 = 0,
	FreeRunProgress_1 = 1,
	FreeRunProgress_PRE_2 = 2,
	FreeRunProgress_2 = 3,
	FreeRunProgress_PRE_3 = 4,
	FreeRunProgress_3 = 5,
	FreeRunProgress_POST_3 = 6
} FreeRunProgress;

@interface FreeRunProgressAnimation : ChallengeInfoTitleCardAnimation {
	CCSprite *panelmarker;
	int flashct;
}
+(FreeRunProgressAnimation*)cons_at:(FreeRunProgress)pos;
@end
