#import "cocos2d.h"

@interface ChallengeModeSelect : CCSprite {
    NSMutableArray *panes;
    CCSprite *pagewindow;
    CCMenuItem *leftarrow, *rightarrow;
    int page_offset;
    
    CCSprite *selectmenu, *chosenmenu;
    
    CCLabelTTF *chosen_name, *chosen_mapname, *chosen_goal;
    CCLabelTTF *reward_amount;
	CCSprite *chosen_preview;
    CCSprite *show_reward;
	CCSprite *show_already_beaten;
	int chosen_level;
}

+(ChallengeModeSelect*)cons;

@end
