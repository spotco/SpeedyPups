#import "MainMenuLayer.h"

@interface NMenuTabShopPage : NMenuPage <GEventListener> {
	CCSprite *tabbedpane;
	
	CCLabelTTF *itemname;
	CCSprite *itemdisp;
	CCLabelTTF *itemdesc;
	CCLabelTTF *itemprice;
	CCSprite *buybutton;
	
	NSMutableArray *touches;
	
	BOOL is_scroll;
	CGPoint last_scroll_pt;
	int scroll_move_ct;
	float vy;
	float clippedholder_y_min, clippedholder_y_max;
	CCSprite *clipperholder;
	
	CCSprite *can_scroll_up, *can_scroll_down;
}

+(NMenuTabShopPage*)cons;

@end
