#import "CCSprite.h"
#import "MainMenuLayer.h"

@interface NMenuSettingsPage : NMenuPage <GEventListener> {
    BOOL kill;
}

+(NMenuSettingsPage*)cons;

@end
