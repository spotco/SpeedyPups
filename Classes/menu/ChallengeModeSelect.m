#import "ChallengeModeSelect.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"

@implementation ChallengeModeSelect

+(ChallengeModeSelect*)cons {
    return [ChallengeModeSelect node];
}

-(id)init {
    self = [super init];
    [self setAnchorPoint:ccp(0,0)];
    
    panes = [[NSMutableArray alloc] init];
    for(int i = 0; i < 8; i++) {
        float wid = (i%4)*0.2-0.3;
        float hei = (i/4)*(-0.35)+0.2;
        [panes addObject:[MenuCommon item_from:TEX_NMENU_LEVELSELOBJ rect:@"panelbutton.png" tar:self sel:@selector(test) pos:[Common screen_pctwid:wid pcthei:hei]]];
    }
    CCMenu *lvls = [CCMenu menuWithItems:nil];
    for (CCMenuItem *i in panes) {
        [lvls addChild:i];
    }
    [self addChild:lvls];
    return self;
}

-(void)test {
    
}

@end
