#import "cocos2d.h"

@class CapeGameEngineLayer;

@interface CapeGameUILayer : CCLayer {
	CapeGameEngineLayer* __unsafe_unretained cape_game;
	
	CCNode *ingame_ui;
	CCNode *pause_ui;
	CCNode *uianim_holder;
	
	NSMutableArray *uianims;
	
	CCLabelTTF *bones_disp, *lives_disp, *time_disp;
	CCSprite *itemlenbarroot, *itemlenbarfill, *itemlenbaricon;
	
	CCLabelTTF *pause_lives_disp, *pause_bones_disp, *pause_time_disp;
	CCSprite *left_curtain, *right_curtain, *bg_curtain;
	CGPoint left_curtain_tpos,right_curtain_tpos,bg_curtain_tpos;
	NSTimer *update_timer;
}

+(CapeGameUILayer*)cons_g:(CapeGameEngineLayer*)g;

-(void)update;
-(void)do_bone_collect_anim:(CGPoint)start;
-(void)do_tutorial_anim;

-(void)update_pct:(float)pct;
-(CCLabelTTF*)bones_disp;
-(CCLabelTTF*)lives_disp;
-(CCLabelTTF*)time_disp;

-(void)exit;

-(void)itembar_set_visible:(BOOL)b;

@end
