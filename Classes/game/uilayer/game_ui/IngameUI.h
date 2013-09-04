#import "cocos2d.h"
#import "InventoryItemPane.h"
#import "Challenge.h"
@class UIEnemyAlert;

@interface IngameUI : CCSprite {
    float enemy_alert_ui_ct;
	UIEnemyAlert *enemy_alert_ui;
	
    MainSlotItemPane *ingame_ui_item_slot;
    float item_duration_pct;
	float item_slot_notify_anim_sc;
	
	CCSprite *itemlenbarfill, *readynotif, *itemlenbarroot,*itemlenbaricon;

	CCSprite *challengedescbg,*challengedescincon;
	CCLabelTTF *challengedesc;
}

@property(readwrite,strong) CCLabelTTF *lives_disp, *bones_disp, *time_disp;

+(IngameUI*)cons;

-(void)set_enemy_alert_ui_ct:(int)i;
-(void)set_item_duration_pct:(float)f;
-(void)update_item_slot;
-(void)update:(GameEngineLayer*)g;

-(void)enable_challengedesc_type:(ChallengeType)type;
-(void)set_challengedesc_string:(NSString*)str;

-(void)animslot_notification;

@end
