#import "cocos2d.h"

@class CapeGameEngineLayer;

@interface CapeGameUILayer : CCLayer {
	CapeGameEngineLayer* __unsafe_unretained cape_game;
	
	CCNode *ingame_ui;
	CCNode *pause_ui;
	CCNode *uianim_holder;
	
	NSMutableArray *uianims;
	
	CCLabelBMFont *bones_disp, *lives_disp, *time_disp;
	CCSprite *itemlenbarroot, *itemlenbarfill, *itemlenbaricon;
	
	CCLabelTTF *pause_lives_disp, *pause_bones_disp, *pause_time_disp, *pause_points_disp;
	CCLabelTTF *pause_new_high_score_disp;
	CCSprite *left_curtain, *right_curtain, *bg_curtain;
	CGPoint left_curtain_tpos,right_curtain_tpos,bg_curtain_tpos;
	NSTimer *update_timer;
	
	CCSprite *scoredispbg;
	CCLabelBMFont *scoredisp;
	CCLabelBMFont *multdisp;
	float multdisp_anim_t;
	
	float current_disp_score;
}

+(CapeGameUILayer*)cons_g:(CapeGameEngineLayer*)g;

-(void)update;
-(void)do_bone_collect_anim:(CGPoint)start;
-(void)do_tutorial_anim;

-(void)update_pct:(float)pct;
-(CCLabelBMFont*)bones_disp;
-(CCLabelBMFont*)lives_disp;
-(CCLabelBMFont*)time_disp;

-(void)exit;

-(void)itembar_set_visible:(BOOL)b;

@end
