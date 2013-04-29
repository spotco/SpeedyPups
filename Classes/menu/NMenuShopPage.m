#import "NMenuShopPage.h"
#import "MenuCommon.h"
#import "Shopkeeper.h"
#import "ShopItemPane.h"
#import "ShopManager.h"

@implementation NMenuShopPage
+(NMenuShopPage*)cons {
    return [NMenuShopPage node];
}
-(id)init {
    self = [super init];
    [GEventDispatcher add_listener:self];
    [self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopmenu" pos:[Common screen_pctwid:0.6 pcthei:0.65]]];
	CCSprite *speechbub = [MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_speechbub" pos:[Common screen_pctwid:0.45 pcthei:0.3]];
	[self addChild:speechbub];
    
    CCMenuItem *tab1 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(shop_tab_items)
                                                       pos:[Common screen_pctwid:0.35 pcthei:0.93]
                                                      text:@"Items" textpos:ccp(55,19) fntsz:20];
    
    
    CCMenuItem *tab2 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(shop_tab_characters)
                                                       pos:[Common screen_pctwid:0.6 pcthei:0.93]
                                                      text:@"Characters" textpos:ccp(57,19) fntsz:20];
    
    CCMenuItem *tab3 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(shop_tab_misc)
                                                       pos:[Common screen_pctwid:0.85 pcthei:0.93]
                                                      text:@"Misc" textpos:ccp(55,19) fntsz:20];
    CCMenuItem *buybutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                               rect:@"buybutton"
                                                tar:self sel:@selector(shop_buy)
                                                pos:[Common screen_pctwid:0.81 pcthei:0.31]];
	
	ShopItemPane *i1 = [ShopItemPane cons_pt:[Common screen_pctwid:0.4 pcthei:0.65] cb:[Common cons_callback:self sel:@selector(shop_pane1)]];
	ShopItemPane *i2 = [ShopItemPane cons_pt:[Common screen_pctwid:0.6 pcthei:0.65] cb:[Common cons_callback:self sel:@selector(shop_pane2)]];
	ShopItemPane *i3 = [ShopItemPane cons_pt:[Common screen_pctwid:0.8 pcthei:0.65] cb:[Common cons_callback:self sel:@selector(shop_pane3)]];
    
	CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS
											 rect:@"nmenu_arrow_left"
											  tar:self sel:@selector(pane_prev)
											  pos:[Common screen_pctwid:0.285 pcthei:0.64]];
	
	CCMenuItem *rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS
											 rect:@"nmenu_arrow_right"
											  tar:self sel:@selector(pane_next)
											  pos:[Common screen_pctwid:0.92 pcthei:0.64]];
	[leftarrow setScaleX:0.75];
	[rightarrow setScaleX:0.75];
    controlm = [CCMenu menuWithItems:tab1,tab2,tab3,buybutton,i1,i2,i3,leftarrow,rightarrow, nil];
    [controlm setPosition:ccp(0,0)];
    [self addChild:controlm];
	
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:UILineBreakModeWordWrap];
    
    CCLabelTTF *infodesc = [CCLabelTTF labelWithString:maxstr
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:12];
    [infodesc setColor:ccc3(0,0,0)];
    [infodesc setAnchorPoint:ccp(0,0.5)];
    [infodesc setPosition:ccp(10,28)];
    [speechbub addChild:infodesc];
	
	CCLabelTTF *infotitle = [Common cons_label_pos:ccp(10,67.5) color:ccc3(205,51,51) fontsize:20 str:@"OBJTITLE"];
	[infotitle setAnchorPoint:ccp(0,0.5)];
	[speechbub addChild:infotitle];
	
	CCSprite *boneicon = [MenuCommon menu_item:TEX_NMENU_ITEMS id:@"boneicon" pos:ccp(125,67.5)];
	[boneicon setScale:0.7];
	[speechbub addChild:boneicon];
    
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
	
	CCLabelTTF *prix = [Common cons_label_pos:ccp(145,67.5) color:ccc3(0,0,0) fontsize:18 str:@"999999"];
	[prix setAnchorPoint:ccp(0,0.5)];
	[speechbub addChild:prix];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
	
	shop = [ShopManager cons];
	[shop set_speechbub:speechbub infotitle:infotitle infodesc:infodesc price:prix itempanes:@[i1,i2,i3] next:rightarrow prev:leftarrow buy:buybutton];
	[shop reset];
	
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

-(void)shop_buy {
	[shop buy_current];
}

-(void)shop_pane1 {
	[shop select_pane:0];
}

-(void)shop_pane2 {
	[shop select_pane:1];
}

-(void)shop_pane3 {
	[shop select_pane:2];
}

-(void)shop_tab_items {
	[shop tab_items];
}

-(void)shop_tab_characters {
	[shop tab_characters];
}

-(void)shop_tab_misc {
	[shop tab_misc];
}

-(void)pane_next {
	[shop pane_next];
}

-(void)pane_prev {
	[shop pane_prev];
}
@end
