#import "CCLayer.h"
#import "Resource.h"
#import "GameEngineLayer.h"
#import "GameStartAnim.h"
#import "UIIngameAnimation.h"
#import "BoneCollectUIAnimation.h"
#import "GEventDispatcher.h"
@class MainSlotItemPane;

@interface UILayer : CCLayer <GEventListener> {
    float item_duration_pct;
    
    GameEngineLayer* game_engine_layer;
    CCNode *ingame_ui,*pause_ui,*gameover_ui,*enemy_alert_ui,*ask_continue_ui;
    int enemy_alert_ui_ct;
    
    UIAnim *curanim;
    NSMutableArray *ingame_ui_anims;
    CCLabelTTF *lives_disp, *bones_disp, *time_disp;
    
    CCLayer *game_end_menu_layer; //todo, change to ui too
    CCLabelTTF *gameover_bones_disp, *gameover_time_disp;
        
    CCLabelTTF *pause_lives_disp, *pause_bones_disp, *pause_time_disp;
    NSArray *pause_menu_item_slots;
    MainSlotItemPane *ingame_ui_item_slot;
}

+(UILayer*)cons_with_gamelayer:(GameEngineLayer*)g;

-(void)start_initial_anim;

@end
