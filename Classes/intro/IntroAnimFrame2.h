#import "IntroAnim.h"

@interface IntroAnimFrame2 : IntroAnimFrame {
	int ct;
	CCSprite *bg;
	CCSprite *ground;
	CCSprite *robot1, *robot2, *robot3;
}

+(IntroAnimFrame2*)cons;

@end
