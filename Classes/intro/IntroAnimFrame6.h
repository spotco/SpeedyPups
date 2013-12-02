#import "cocos2d.h"
#import "IntroAnim.h"

@interface IntroAnimFrame6 : IntroAnimFrame {
	int ct;
	CCSprite *bg;
	CCSprite *ground;

	CCSprite *dog1, *dog2, *dog3, *copter;
	
	CGPoint dog1_tar_pos, dog2_tar_pos, dog3_tar_pos, copter_tar_pos;
}

+(IntroAnimFrame6*)cons;

@end
