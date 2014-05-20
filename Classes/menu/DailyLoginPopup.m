#import "DailyLoginPopup.h"
#import "FileCache.h"
#import "Resource.h"
#import "MenuCommon.h"

@implementation DailyLoginPopup

+(DailyLoginPopup*)cons {
	return [[DailyLoginPopup node] cons];
}

-(id)cons {
	[super cons];
	
	return self;
}

-(void)add_close_button:(CallBack *)on_close {
	[super add_close_button:on_close];
	
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
											   rect:@"nmenu_okbutton"
												tar:on_close.target sel:on_close.selector
												pos:CGPointZero];
	[closebutton setScale:0.8];
	[closebutton setAnchorPoint:ccp(0.5,0)];
    [closebutton setPosition:[Common pct_of_obj:self pctx:0.5 pcty:0.05]];
	CCMenu *invmh = [CCMenu menuWithItems:closebutton, nil];
	[invmh setPosition:CGPointZero];
    [self addChild:invmh];
}

@end
