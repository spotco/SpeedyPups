#import "cocos2d.h"
#import "IntroAnim.h"

@interface IntroAnimFrame4 : IntroAnimFrame {
	CCSprite *bg;
	
	CCSprite *dleft,*dright,*curtains;
	CCSprite *spotlight, *copter, *exclamation;
	int ct;
}

+(IntroAnimFrame4*)cons;

@end