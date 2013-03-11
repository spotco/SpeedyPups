#import "NMenuCharSelectPage.h"
#import "MenuCommon.h"
#import "Player.h"

@implementation NMenuCharSelectPage

+(NMenuCharSelectPage*)cons {
    return [NMenuCharSelectPage node];
}

-(id)init {
    self = [super init];

    //[MenuCommon cons_run_anim:[Player get_character]]
    
    CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_left" tar:self sel:@selector(arrow_left) pos:[Common screen_pctwid:0.3 pcthei:0.35]];
    CCMenuItem *rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_right" tar:self sel:@selector(arrow_right) pos:[Common screen_pctwid:0.7 pcthei:0.35]];
    CCMenu *m = [CCMenu menuWithItems:leftarrow,rightarrow, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_spotlight" pos:[Common screen_pctwid:0.5 pcthei:0.55]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_curtains" pos:[Common screen_pctwid:0.5 pcthei:0.95]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_charselmenu" pos:[Common screen_pctwid:0.5 pcthei:0.75]]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    
    return self;
}

-(void)arrow_left {
    NSLog(@"sel left");
}

-(void)arrow_right {
    NSLog(@"sel right");
}

@end
