#import "MainMenuLayer.h"

@interface NMenuCharSelectPage : NMenuPage <GEventListener> {
    CCSprite* dog_spr,*spotlight;
    CCMenu *controlm;
	CCMenuItem *select;
    int cur_dog;
    
    CCLabelTTF *infodesc;
    
    bool kill;
}

+(NMenuCharSelectPage*)cons;

@end
