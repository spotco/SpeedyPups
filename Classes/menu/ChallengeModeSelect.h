#import "cocos2d.h"

@interface ChallengeModeSelect : CCSprite {
    NSMutableArray *panes;
    CCMenuItem *leftarrow, *rightarrow;
    int page_offset;
}

+(ChallengeModeSelect*)cons;

@end
