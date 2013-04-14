#import "CoinCollectUIAnimation.h"
#import "Resource.h" 

@implementation CoinCollectUIAnimation

#define CTMAX 50

+(CoinCollectUIAnimation*)cons_start:(CGPoint)start end:(CGPoint)end {
    return [[CoinCollectUIAnimation node] init_start:start end:end];
}

-(id)init_start:(CGPoint)tstart end:(CGPoint)tend {
    start = tstart;
    end = tend;
    ct = CTMAX;
    [self addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_STARCOIN]]];
    
    return self;
}

@end
