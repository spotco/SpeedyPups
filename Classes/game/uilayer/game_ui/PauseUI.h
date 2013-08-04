#import "cocos2d.h"

@interface PauseUI : CCSprite {
    CCLabelTTF *pause_lives_disp, *pause_bones_disp, *pause_time_disp;
    CCLabelTTF *challenge_disp;
	
	//CCSprite *item_icon;
	//CCLabelTTF *item_desc_name, *item_desc;
}

+(PauseUI*)cons;
-(void)update_labels_lives:(NSString*)lives bones:(NSString*)bones time:(NSString*)time;
-(void)set_challenge_msg:(NSString*)msg;
//-(void)update_item_slot;
@end
