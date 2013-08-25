#import "CCSprite.h"
#import "MainMenuLayer.h"

@interface NMenuSettingsPage : NMenuPage <GEventListener> {
	CCSprite *clipper_anchor;
	CCSprite *scroll_left_arrow, *scroll_right_arrow;
	CCSprite *selector_icon;
	
	CGPoint selector_icon_target_pos;
	
	BOOL is_scroll;
	CGPoint last_scroll_pt;
	int scroll_move_ct;
	float vx;
	float clippedholder_x_min, clippedholder_x_max;
	NSMutableArray *touches;

}

+(NMenuSettingsPage*)cons;

@end
