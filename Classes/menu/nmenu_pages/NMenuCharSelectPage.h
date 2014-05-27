#import "MainMenuLayer.h"

@interface NMenuCharSelectPage : NMenuPage <GEventListener> {
    CCSprite* dog_spr,*spotlight;
    CCMenu *controlm;
	CCMenuItem *select;
    int cur_dog;
    
    //CCLabelTTF *infodesc;
    CCSprite *available_disp;
    CCLabelBMFont *name_disp;
    CCLabelBMFont *power_disp;
    
    CCSprite *locked_disp;
    
    bool kill;
	
	CCMenu *nav_menu;
	float charselfbutton_anim_scale;
}

+(NMenuCharSelectPage*)cons;

@end
