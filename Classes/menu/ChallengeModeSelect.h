#import "cocos2d.h"
@class CCLabelTTF_Pooled;

@interface ChallengeModeSelect : CCSprite {
    NSMutableArray *panes;
    CCSprite *pagewindow;
    CCMenuItem *leftarrow, *rightarrow;
    int page_offset;
    
    CCSprite *selectmenu, *chosenmenu;
    
	CCLabelTTF *chosen_goal;
    CCLabelBMFont *chosen_name, *chosen_mapname;
    CCLabelBMFont *reward_amount;
	
	CCSprite *chosen_preview;
    CCSprite *show_reward;
	CCSprite *show_already_beaten;
	int chosen_level;
}

+(ChallengeModeSelect*)cons;

@end
