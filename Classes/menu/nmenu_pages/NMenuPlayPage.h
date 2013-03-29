#import "CCSprite.h"
#import "MainMenuLayer.h"
#import "BirdFlock.h"
#import "ChallengeModeSelect.h"

typedef enum {
    PlayPageMode_WAIT,
    PlayPageMode_DOGRUN,
    PlayPageMode_SCROLLUP,
    PlayPageMode_EXIT,
    PlayPageMode_MODE_CHOOSE,
    PlayPageMode_CHALLENGE_SELECT,
    PlayPageMode_CHALLENGE_VIEW
} PlayPageMode;

@interface NMenuPlayPage : NMenuPage <GEventListener> {
    PlayPageMode cur_mode;
    BirdFlock *birds;
    
    CCMenuItem *playbutton;
    CCSprite *logo;
    CCMenu *nav_menu,*mode_choose_menu;
    ChallengeModeSelect *challengeselect;

    CCSprite *rundog;
    
    int ct;
    float scrollup_pct;
    
    BOOL kill;
}

+(NMenuPlayPage*)cons;

@end
