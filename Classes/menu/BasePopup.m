#import "BasePopup.h"
#import "FileCache.h" 
#import "Resource.h"
#import "MenuCommon.h"

@implementation BasePopup

+(BasePopup*)cons {
	return [[BasePopup node] cons];
}

-(id)cons {
	[self setTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"popup_back"]];
	[self setPosition:[Common screen_pctwid:0.5 pcthei:0.5]];
	return self;
}

-(void)add_close_button:(CallBack *)on_close {
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
											   rect:@"nmenu_closebutton"
												tar:on_close.target sel:on_close.selector
												pos:CGPointZero];
    [closebutton setPosition:[Common pct_of_obj:self pctx:0.975 pcty:0.95]];
	CCMenu *invmh = [CCMenu menuWithItems:closebutton, nil];
	[invmh setPosition:CGPointZero];
    [self addChild:invmh];
}

-(void)dealloc {
	[self removeAllChildrenWithCleanup:YES];
}

@end
