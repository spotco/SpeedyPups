#import "cocos2d.h"

@interface ChallengeModeSelect : CCSprite {
    NSMutableArray *panes;
    CCSprite *pagewindow;
    CCMenuItem *leftarrow, *rightarrow;
    int page_offset;
    
    CCSprite *selectmenu, *chosenmenu;
    
    CCLabelTTF *chosen_name, *chosen_goal;
    CCSprite *chosen_star,*chosen_preview;
    int chosen_level;
}

+(ChallengeModeSelect*)cons;

@end
