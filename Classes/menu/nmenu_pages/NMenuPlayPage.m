#import "NMenuPlayPage.h"
#import "MenuCommon.h"
#import "Flowers.h"

@implementation NMenuPlayPage

+(NMenuPlayPage*)cons {
    return [NMenuPlayPage node];
}

-(id)init {
    self = [super init];
    
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_logo" pos:[Common screen_pctwid:0.5 pcthei:0.8]]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_runbutton"
                                               tar:self sel:@selector(run)
                                               pos:[Common screen_pctwid:0.5 pcthei:0.45]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    
    [self addChild:[Flowers cons_pt:[Common screen_pctwid:0.275 pcthei:0.35]]];
    
    CCMenu *m = [CCMenu menuWithItems:playbutton, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    return self;
}

-(void)run {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_PLAY_AUTOLEVEL_MODE]];
}



@end
