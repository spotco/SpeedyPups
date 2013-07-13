#import "cocos2d.h"
#import "InventoryItemPane.h"

@interface IngameUI : CCSprite {
    int enemy_alert_ui_ct;
    CCNode *enemy_alert_ui;
    MainSlotItemPane *ingame_ui_item_slot;
    float item_duration_pct;
	
	CCSprite *itemlenbarfill, *readynotif, *itemlenbarroot,*itemlenbaricon;
}

@property(readwrite,strong) CCLabelTTF *lives_disp, *bones_disp, *time_disp;

+(IngameUI*)cons;

-(void)set_enemy_alert_ui_ct:(int)i;

-(void)set_item_duration_pct:(float)f;

-(void)update_item_slot;
-(void)update:(GameEngineLayer*)g;

@end
