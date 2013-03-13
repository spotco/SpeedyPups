#import "MainMenuLayer.h"

@interface NMenuCharSelectPage : NMenuPage {
    CCSprite* dog_spr,*spotlight;
    int cur_dog;
}

+(NMenuCharSelectPage*)cons;

@end
