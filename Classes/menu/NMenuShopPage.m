#import "NMenuShopPage.h"
#import "MenuCommon.h"
#import "Shopkeeper.h"

@implementation NMenuShopPage
+(NMenuShopPage*)cons {
    return [NMenuShopPage node];
}
-(id)init {
    self = [super init];
    [GEventDispatcher add_listener:self];
    [self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopmenu" pos:[Common screen_pctwid:0.6 pcthei:0.65]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_speechbub" pos:[Common screen_pctwid:0.425 pcthei:0.35]]];
    
    CCMenuItem *tab1 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.35 pcthei:0.93]
                                                      text:@"Items" textpos:ccp(55,19) fntsz:20];
    
    
    CCMenuItem *tab2 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.6 pcthei:0.93]
                                                      text:@"Characters" textpos:ccp(57,19) fntsz:20];
    
    CCMenuItem *tab3 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.85 pcthei:0.93]
                                                      text:@"Misc" textpos:ccp(55,19) fntsz:20];
    
    /*CCMenuItem *buybutton = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_shoptab"
                                                   tar:self sel:@selector(tab1)
                                                   pos:[Common screen_pctwid:0.84 pcthei:0.31]
                                                  text:@"BUY" textpos:ccp(55,22) fntsz:30];*/
    CCMenuItem *buybutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                               rect:@"buybutton"
                                                tar:self sel:@selector(tab1)
                                                pos:[Common screen_pctwid:0.81 pcthei:0.31]];
    //[buybutton setScale:1.25];
    
    controlm = [CCMenu menuWithItems:tab1,tab2,tab3,buybutton, nil];
    [controlm setPosition:ccp(0,0)];
    [self addChild:controlm];
    
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [controlm setVisible:NO];
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        [controlm setVisible:YES];
        
    }
}

+(CCMenuItem*)labeleditem_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos text:(NSString*)text textpos:(CGPoint)tpos fntsz:(int)fntsz{
    CCSprite* p_a = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_a addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:fntsz str:text]];
    
    CCSprite *p_b = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_b addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:fntsz str:text]];
    
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    
    CCMenuItemSprite *p = [CCMenuItemSprite itemFromNormalSprite:p_a
                                                  selectedSprite:p_b
                                                          target:tar
                                                        selector:sel];
    [p setPosition:pos];
    
    return p;
}

-(void)tab1 {
    NSLog(@"tab1");
}
@end
