#import "MainMenuLayer.h"

@interface NMenuCharSelectPage : NMenuPage <GEventListener> {
    CCSprite* dog_spr,*spotlight;
    CCMenu *controlm;
    int cur_dog;
    
    bool kill;
}

+(NMenuCharSelectPage*)cons;

@end
