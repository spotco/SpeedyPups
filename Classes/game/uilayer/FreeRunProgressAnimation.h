#import "UIIngameAnimation.h"
#import "ChallengeInfoTitleCardAnimation.h"
#import "FreeRunStartAtManager.h"

@interface FreeRunProgressAnimation : ChallengeInfoTitleCardAnimation {
	CCSprite *panelmarker;
	int flashct;
}
+(FreeRunProgressAnimation*)cons_at:(FreeRunProgress)pos;
@end
