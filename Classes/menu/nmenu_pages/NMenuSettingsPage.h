#import "CCSprite.h"
#import "MainMenuLayer.h"

@interface NMenuSettingsPage : NMenuPage <GEventListener> {
	CCSprite *clipper_anchor;
	CCSprite *scroll_left_arrow, *scroll_right_arrow;
	CCSprite *selector_icon;

}

+(NMenuSettingsPage*)cons;

@end
