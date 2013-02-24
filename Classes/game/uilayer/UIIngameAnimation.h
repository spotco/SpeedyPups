#import "CCSprite.h"
#import "UIAnim.h"

@interface UIIngameAnimation : CCSprite  {
    int ct;
}

@property(readwrite,assign) int ct;
-(void)update;

@end
