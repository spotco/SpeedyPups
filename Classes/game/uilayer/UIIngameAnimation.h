#import "CCSprite.h"
#import "UIAnim.h"

@interface UIIngameAnimation : CCSprite  {
    float ct;
}

@property(readwrite,assign) float ct;
-(void)update;

@end
