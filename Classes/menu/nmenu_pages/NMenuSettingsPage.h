#import "CCSprite.h"
#import "MainMenuLayer.h"

@interface NMenuSettingsPage : NMenuPage <GEventListener> {
    BOOL kill;
	CCMenuItemSprite *do_tutorial;
	CCLabelTTF *do_tutorial_label;
}

+(NMenuSettingsPage*)cons;

@end
