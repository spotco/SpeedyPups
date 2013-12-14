#import "cocos2d.h"
#import "IntroAnim.h"

@interface IntroAnimFrame3 : IntroAnimFrame {
	CCSprite *bg;
	
	CCSprite *dleft,*dright,*pups, *curtains;
	int ct;
    
    NSMutableArray *debris;
}

+(IntroAnimFrame3*)cons;

@end
