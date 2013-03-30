#import "ChallengeModeSelect.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"

@implementation ChallengeModeSelect

+(ChallengeModeSelect*)cons {
    return [ChallengeModeSelect node];
}

-(id)init {
    self = [super init];
    [self setAnchorPoint:ccp(0,0)];
    
    
    CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS
                                             rect:@"nmenu_arrow_left"
                                              tar:self sel:@selector(arrow_left)
                                              pos:[Common screen_pctwid:0.09 pcthei:0.36]];
    CCMenuItem *rightarrow = [MenuCommon
                              item_from:TEX_NMENU_ITEMS
                              rect:@"nmenu_arrow_right"
                              tar:self sel:@selector(arrow_right)
                              pos:[Common screen_pctwid:0.84 pcthei:0.36]];
    
    CCMenu *selmenu = [CCMenu menuWithItems:leftarrow,rightarrow, nil];
    [selmenu setPosition:ccp(0,0)];
    [self addChild:selmenu];
    
    panes = [[NSMutableArray alloc] init];
    for(int i = 0; i < 8; i++) {
        float wid = (i%4)*0.17-0.29;
        float hei = (i/4)*(-0.3)+0.02;
        [panes addObject:[MenuCommon
                          item_from:TEX_NMENU_LEVELSELOBJ
                          rect:@"panelbutton.png"
                          tar:self sel:@selector(test)
                          pos:[Common screen_pctwid:wid pcthei:hei]]];
    }
    CCMenu *lvls = [CCMenu menuWithItems:nil];
    for (CCMenuItem *i in panes) {
        [lvls addChild:i];
    }
    [self addChild:lvls];
    
    [self setPosition:ccp(23,50)];
    return self;
}

-(void)close {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_STARTING_PAGE_ID i2:0]];
}

-(void)arrow_left {
    
}

-(void)arrow_right {
    
}

-(void)test {
    
}

@end
