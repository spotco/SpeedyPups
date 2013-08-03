#import "MainMenuLayer.h"

@interface NMenuCharSelectPage : NMenuPage <GEventListener> {
    CCSprite* dog_spr,*spotlight;
    CCMenu *controlm;
	CCMenuItem *select;
    int cur_dog;
    
    CCLabelTTF *infodesc;
    
    bool kill;
	
	CCMenu *nav_menu;
	float charselfbutton_anim_scale;
}

+(NMenuCharSelectPage*)cons;

@end
