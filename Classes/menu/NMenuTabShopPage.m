#import "NMenuTabShopPage.h"
#import "Shopkeeper.h"
#import "MenuCommon.h"


@implementation NMenuTabShopPage

+(NMenuTabShopPage*)cons {
	return [NMenuTabShopPage node];
}

-(id)init {
	self = [super init];
	[GEventDispatcher add_listener:self];
	[self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
	[self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
	[self addChild:[MenuCommon cons_common_nav_menu]];
	
	CCSprite *tabbedpane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												   rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabbedshoppane"]]
							pos:[Common screen_pctwid:0.615 pcthei:0.575]];
	
	touches = [NSMutableArray array];
	
	TouchButton *tab1 = [TouchButton cons_pt:[Common pct_of_obj:tabbedpane pctx:0.5 pcty:0.5]
										 tex:[Resource get_tex:TEX_NMENU_ITEMS]
									 texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabpane_tab"]
										  cb:[Common cons_callback:self sel:@selector(test)]];
	
	[touches addObject:tab1];
	[tabbedpane addChild:tab1];
	
	//CCMenuItemSprite
	
	
	[self addChild:tabbedpane];
	return self;
}

-(void)test {
	NSLog(@"test");
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        //[controlm setVisible:NO];
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        //[controlm setVisible:YES];
        
    }
}

-(void)touch_begin:(CGPoint)pt {
	for (TouchButton *b in touches) {
		[b touch_begin:pt];
	}
}

@end
