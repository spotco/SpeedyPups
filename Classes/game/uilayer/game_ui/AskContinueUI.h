#import "cocos2d.h"

@interface AskContinueUI : CCSprite {
    CCLabelTTF *countdown_disp,*cost_disp,*total_disp;
    int countdown_ct;
    
    int continue_cost;
}

+(AskContinueUI*)cons;
-(void)start_countdown:(int)cost;

@end
