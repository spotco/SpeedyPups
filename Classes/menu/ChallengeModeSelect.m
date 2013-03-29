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
    
    CGRect windowsize = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_inventorypane"];
    CCSprite *window = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:windowsize];
    [window setPosition:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:window];
    
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                               rect:@"nmenu_closebutton"
                                                tar:self sel:@selector(close)
                                                pos:ccp(windowsize.size.width/2.25,windowsize.size.height/4)];
    
    CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_left" tar:self sel:@selector(arrow_left) pos:ccp(-windowsize.size.width/2.3,-windowsize.size.height/4.5)];
    CCMenuItem *rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_right" tar:self sel:@selector(arrow_right) pos:ccp(windowsize.size.width/2.75,-windowsize.size.height/4.5)];
    
    [window addChild:[CCMenu menuWithItems:closebutton,leftarrow,rightarrow, nil]];
    
    panes = [[NSMutableArray alloc] init];
    for(int i = 0; i < 8; i++) {
        float wid = (i%4)*0.17-0.29;
        float hei = (i/4)*(-0.3)+0.02;
        [panes addObject:[MenuCommon item_from:TEX_NMENU_LEVELSELOBJ rect:@"panelbutton.png" tar:self sel:@selector(test) pos:[Common screen_pctwid:wid pcthei:hei]]];
    }
    CCMenu *lvls = [CCMenu menuWithItems:nil];
    for (CCMenuItem *i in panes) {
        [lvls addChild:i];
    }
    [window addChild:lvls];
    
    [window addChild:[Common cons_label_pos:ccp(windowsize.size.width/2,windowsize.size.height) color:ccc3(0, 0, 0) fontsize:25 str:@"Challenge Select"]];
    
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
