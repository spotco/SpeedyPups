#import "cocos2d.h"

typedef enum {
	AskContinueUI_COUNTDOWN,
	AskContinueUI_COUNTDOWN_PAUSED,
	AskContinueUI_YES_TRANSFER_MONEY,
	AskContinueUI_YES_RUNOUT,
	AskContinueUI_TRANSITION_TO_GAMEOVER
} AskContinueUI_MODE;

@interface AskContinueUI : CCSprite {
	CCNode *ask_continue_ui;
	CCMenu *yesnomenu;
	CCSprite *playericon;
	int player_anim_ct;
	
	int mod_ct;
	AskContinueUI_MODE curmode;
	
	CCSprite *continue_logo;
	
    CCLabelTTF *countdown_disp;
	float countdown_disp_scale;
    int countdown_ct;
    int continue_cost;
	int actual_next_continue_price;
	
	CCSprite *continue_price_pane;
	float continue_price_pane_vs;
	
	CCLabelTTF *continue_price;
	CCLabelTTF *total_disp;
	NSMutableArray *bone_anims;
	
	CCSprite *left_curtain, *right_curtain, *bg_curtain;
	CGPoint left_curtain_tpos, right_curtain_tpos, bg_curtain_tpos;
}

+(AskContinueUI*)cons;
-(void)start_countdown:(int)cost;

@end
