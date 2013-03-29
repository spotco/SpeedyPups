#import "MainMenuInventoryLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"

@implementation MainMenuInventoryLayer

+(MainMenuInventoryLayer*)cons {
    return [MainMenuInventoryLayer node];
}

-(id)init {
    self = [super init];
    
    [GEventDispatcher add_listener:self];
    
    CGRect windowsize = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_inventorypane"];
    inventory_window = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                              rect:windowsize];
    [inventory_window setPosition:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:inventory_window];
    
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                             rect:@"nmenu_closebutton"
                                              tar:self sel:@selector(close)
                                              pos:ccp(windowsize.size.width/2.25,windowsize.size.height/4)];
    
    [inventory_window addChild:[CCMenu menuWithItems:closebutton, nil]];
    [inventory_window setVisible:NO];
    
    [inventory_window addChild:[Common cons_label_pos:ccp(windowsize.size.width/2,windowsize.size.height) color:ccc3(0, 0, 0) fontsize:25 str:@"Inventory"]];
    
    
    return self;
}

-(void)open {
    [inventory_window setVisible:YES];
}

-(void)close {
    [inventory_window setVisible:NO];
    [GEventDispatcher push_event:[GEvent cons_type:GEVentType_MENU_CLOSE_INVENTORY]];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [self open];
    }
}

@end
