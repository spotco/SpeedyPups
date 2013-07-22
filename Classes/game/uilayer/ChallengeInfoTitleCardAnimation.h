#import "UIIngameAnimation.h"
@class GameEngineLayer;

typedef enum {
	TitleCardMode_DOWN,
	TitleCardMode_STAY,
	TitleCardMode_UP
} TitleCardMode;

@interface ChallengeInfoTitleCardAnimation : UIIngameAnimation {
	CCSprite *base;
	int animct;
	TitleCardMode mode;
}
+(ChallengeInfoTitleCardAnimation*)cons_g:(GameEngineLayer*)g;
@end
