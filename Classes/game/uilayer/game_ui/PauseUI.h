#import "cocos2d.h"

@interface PauseUI : CCSprite {
    CCLabelTTF *pause_lives_disp, *pause_bones_disp, *pause_time_disp;
    NSArray *pause_menu_item_slots;
}

+(PauseUI*)cons;
-(void)update_item_slots;
-(void)update_labels_lives:(NSString*)lives bones:(NSString*)bones time:(NSString*)time;
@end
