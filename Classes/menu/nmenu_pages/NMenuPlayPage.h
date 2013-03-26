#import "CCSprite.h"
#import "MainMenuLayer.h"
#import "BirdFlock.h"

typedef enum {
    PlayPageMode_WAIT,
    PlayPageMode_DOGRUN,
    PlayPageMode_SCROLLUP,
    PlayPageMode_EXIT
} PlayPageMode;

@interface NMenuPlayPage : NMenuPage <GEventListener> {
    PlayPageMode cur_mode;
    BirdFlock *birds;
    
    CCMenuItem *playbutton;
    CCSprite *logo;
    CCMenu *nav_menu;

    CCSprite *rundog;
    
    int ct;
}

+(NMenuPlayPage*)cons;

@end
