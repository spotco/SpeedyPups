#import "IngameUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"
#import "LauncherRocket.h"
#import "UIEnemyAlert.h"
#import "UIWaterAlert.h"

@implementation MRectCCMenuItemImage
-(CGRect)rect {
	CGRect rect = [super rect];
	rect.size.width += 20;
	rect.size.height += 20;
	return rect;
}
@end

@implementation IngameUI

@synthesize lives_disp,bones_disp,time_disp;

+(IngameUI*)cons {
    return [IngameUI node];
}

#define ITEM_LENBAR_HIDE_DURATION 10.0f
#define ITEM_LENBAR_DEFAULT_POSITION [Common screen_pctwid:0.82 pcthei:0.09]
#define ITEM_LENBAR_HIDDEN_POSITION [Common screen_pctwid:0.82 pcthei:-0.2]

-(id)init {
    self = [super init];
	
	CCSprite *pauseicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseicon"]];
	CCSprite *pauseiconzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseicon"]];
	
    [UICommon set_zoom_pos_align:pauseicon zoomed:pauseiconzoom scale:1.4];
    
    CCMenuItemImage *ingamepause = [MRectCCMenuItemImage itemFromNormalSprite:pauseicon
                                                          selectedSprite:pauseiconzoom
                                                                  target:self
                                                                selector:@selector(pause)];
    [ingamepause setPosition:ccp(
		[Common SCREEN].width-pauseicon.boundingBoxInPixels.size.width+10,
		[Common SCREEN].height-pauseicon.boundingBoxInPixels.size.height+10
	)];
	
	CCSprite *bone_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_bone_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.96]];
	CCSprite *lives_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_lives_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.88]];
	CCSprite *time_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_time_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.8]];
	
	bones_disp = [[Common cons_label_pos:[Common pct_of_obj:bone_disp_icon pctx:0.5 pcty:0.42] color:ccc3(200,30,30) fontsize:13 str:@""] anchor_pt:ccp(0,0.5)];
	lives_disp = [[Common cons_label_pos:[Common pct_of_obj:lives_disp_icon pctx:0.5 pcty:0.412] color:ccc3(200,30,30) fontsize:15 str:@""] anchor_pt:ccp(0,0.5)];
	time_disp = [[Common cons_label_pos:[Common pct_of_obj:time_disp_icon pctx:0.5 pcty:0.44] color:ccc3(200,30,30) fontsize:12 str:@""] anchor_pt:ccp(0,0.5)];
	
	[bone_disp_icon addChild:bones_disp];
	[lives_disp_icon addChild:lives_disp];
	[time_disp_icon addChild:time_disp];
	
	[self addChild:bone_disp_icon];
	[self addChild:lives_disp_icon];
	[self addChild:time_disp_icon];
	
	enemy_alert_ui = [UIEnemyAlert cons];
	[enemy_alert_ui setVisible:NO];
	[self addChild:enemy_alert_ui];
	
	water_alert_ui = [UIWaterAlert cons];
	[self addChild:water_alert_ui];
	
    ingame_ui_item_slot = [MainSlotItemPane cons_pt:[Common screen_pctwid:0.93 pcthei:0.09] cb:[Common cons_callback:self sel:@selector(itemslot_use)] slot:0];
    [ingame_ui_item_slot setScale:0.75];
    [ingame_ui_item_slot setOpacity:120];
    
    CCMenu *ingame_ui = [CCMenu menuWithItems:
                 ingamepause,
                 ingame_ui_item_slot,
                 nil];
    
    ingame_ui.anchorPoint = ccp(0,0);
    ingame_ui.position = ccp(0,0);
    [self addChild:ingame_ui];
	
	itemlenbarroot = [CCSprite node];
	CCSprite *itemlenbarback = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																					 idname:@"item_timebaremptytex"]];
	[itemlenbarroot addChild:itemlenbarback];
	itemlenbarfill = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																					 idname:@"item_timebarfulltex"]];
	[itemlenbarroot addChild:itemlenbarfill];
	
	[itemlenbarback setAnchorPoint:ccp(0,0.5)];
	[itemlenbarfill setAnchorPoint:ccp(0,0.5)];
	
	[itemlenbarback setPosition:ccp(-72,0)];
	[itemlenbarfill setPosition:ccp(-72,0)];
	
	[itemlenbarroot addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																				   idname:@"item_timebar"]]];
	[itemlenbarroot setPosition:ITEM_LENBAR_HIDDEN_POSITION];
	
	itemlenbar_target_pos = ITEM_LENBAR_HIDDEN_POSITION;
	
    [self addChild:itemlenbarroot];
	[itemlenbarfill setScaleX:0.5];
	for (CCSprite *i in [itemlenbarroot children]) {
		[i setOpacity:175];
	}
	itemlenbaricon = [CCSprite node];
	[itemlenbaricon setPosition:ccp(55,0)];
	[itemlenbaricon setScale:0.8];
	[itemlenbaricon setOpacity:200];
	[itemlenbarroot addChild:itemlenbaricon];
	
	readynotif = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
												  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																				 idname:@"item_ready"]];
	[readynotif setPosition:[Common screen_pctwid:0.855 pcthei:0.18]];
	[readynotif setOpacity:220];
	[self addChild:readynotif];
	[readynotif setVisible:NO];
	
	challengedescbg = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																					  idname:@"challengedescbg"]]
								 pos:[Common screen_pctwid:0.01 pcthei:0.07]];
	[challengedescbg setAnchorPoint:ccp(0,0.5)];
	[challengedescbg setOpacity:180];
	[self addChild:challengedescbg];
	
	challengedesc = [Common cons_label_pos:ccp(0,0) color:ccc3(0, 0, 0) fontsize:25 str:@""];
	[challengedesc setPosition:[Common pct_of_obj:challengedescbg pctx:0.32 pcty:0.5]];
	[challengedesc setAnchorPoint:ccp(0,0.5)];
	[challengedescbg addChild:challengedesc];
	
	TexRect *challengetr = [ChallengeRecord get_for:ChallengeType_COLLECT_BONES];
	challengedescincon = [[CCSprite spriteWithTexture:challengetr.tex rect:challengetr.rect]
									pos:[Common pct_of_obj:challengedescbg pctx:0.05 pcty:0.5]];
	[challengedescincon setAnchorPoint:ccp(0,0.5)];
	[challengedescbg addChild:challengedescincon];
	
	[challengedescbg setVisible:NO];
	
	item_slot_notify_anim_sc = 1;
	
	
	
    return self;
}

-(void)pause {
    UILayer *p = (UILayer*)[self parent];
    [p pause];
	[AudioManager playsfx:SFX_MENU_UP];
}

-(void)itemslot_use {
    UILayer *p = (UILayer*)[self parent];
    [p itemslot_use];
	TexRect *curitem = [GameItemCommon texrect_from:[UserInventory get_current_gameitem]];
	itemlenbaricon.texture = curitem.tex;
	itemlenbaricon.textureRect = curitem.rect;
}

-(void)enable_challengedesc_type:(ChallengeType)type {
	[challengedescbg setVisible:YES];
	TexRect *challengetr = [ChallengeRecord get_for:type];
	challengedescincon.texture = challengetr.tex;
	challengedescincon.textureRect = challengetr.rect;
	challengedesc.string = @"";
}

-(void)set_challengedesc_string:(NSString*)str {
	[challengedesc setString:str];
}

static GameItem last_item = Item_NOITEM;
static int ct  = 0;
-(void)update:(GameEngineLayer*)g {
	ct ++;
	item_slot_notify_anim_sc = item_slot_notify_anim_sc - (item_slot_notify_anim_sc-1)/3;
	[ingame_ui_item_slot setScale:item_slot_notify_anim_sc];

	[enemy_alert_ui update:g];
	[water_alert_ui update:g];
    
    [self set_label:bones_disp to:strf("%i",[g get_num_bones])];
    [self set_label:lives_disp to:strf("\u00B7 %s",[g get_lives] == GAMEENGINE_INF_LIVES ? "\u221E":strf("%i",[g get_lives]).UTF8String)];
    [self set_label:time_disp to:[UICommon parse_gameengine_time:[g get_time]]];
	
	[itemlenbarroot setPosition:ccp(
		itemlenbarroot.position.x + (itemlenbar_target_pos.x - itemlenbarroot.position.x)/4.0,
		itemlenbarroot.position.y + (itemlenbar_target_pos.y - itemlenbarroot.position.y)/4.0
	 )];
		
	if (item_duration_pct > 0) {
		[itemlenbarroot setVisible:YES];
		[ingame_ui_item_slot setVisible:NO];
		[readynotif setVisible:NO];
		[itemlenbarfill setScaleX:item_duration_pct];
		itemlenbar_target_pos = ITEM_LENBAR_DEFAULT_POSITION;
		
	} else {
		//[itemlenbarroot setVisible:NO];
		itemlenbar_target_pos = ITEM_LENBAR_HIDDEN_POSITION;
		
		[ingame_ui_item_slot set_locked:NO];
		if ([UserInventory get_current_gameitem] != Item_NOITEM) {
			[readynotif setVisible:YES];
			[ingame_ui_item_slot setVisible:YES];
			if (last_item != [UserInventory get_current_gameitem]) [self update_item_slot];
			[readynotif setVisible:(ct/25)%2==0];
		} else {
			[ingame_ui_item_slot set_locked:YES];
			[readynotif setVisible:NO];
			[ingame_ui_item_slot setVisible:NO];
		}
	}
	last_item = [UserInventory get_current_gameitem];
	
	if (challengedescbg.visible) {
		ChallengeInfo *cinfo = [g get_challenge];
		NSString *tar_str = @"top lel";
		if (cinfo.type == ChallengeType_COLLECT_BONES) {
			if ([g get_num_bones] >= cinfo.ct) {
				[challengedesc setColor:ccc3(0,255,0)];
			} else {
				[challengedesc setColor:ccc3(0,0,0)];
			}
			tar_str = strf("%i/%i",[g get_num_bones],cinfo.ct);
			
		} else if (cinfo.type == ChallengeType_FIND_SECRET) {
			if ([g get_num_secrets] >= cinfo.ct) {
				[challengedesc setColor:ccc3(0,255,0)];
			} else {
				[challengedesc setColor:ccc3(0,0,0)];
			}
			tar_str = strf("%i/%i",[g get_num_secrets],cinfo.ct);
			
		} else if (cinfo.type == ChallengeType_TIMED) {
			int tm = cinfo.ct - [g get_time];
			if (tm <= 0) {
				if ([[UICommon parse_gameengine_time:tm] isEqualToString:@"0:00"]) {
					[challengedesc setColor:ccc3(255,186,0)];
					tar_str = @"0:00";
				} else {
					[challengedesc setColor:ccc3(255,0,0)];
					tar_str = @"failed";
				}
			} else {
				tar_str = [UICommon parse_gameengine_time:tm];
				[challengedesc setColor:ccc3(0,0,0)];
			}
			
		}
		if (![tar_str isEqualToString:challengedesc.string]) {
			[challengedesc setString:tar_str];
		}
	}
	
}

-(void)set_label:(CCLabelTTF*)l to:(NSString*)s {
    if (![[l string] isEqualToString:s]) {
        [l setString:s];
    }
}

-(void)set_enemy_alert_ui_ct:(int)i {
    [enemy_alert_ui set_ct:i];
}

-(void)set_item_duration_pct:(float)f {
    item_duration_pct = f;
	if (f == 0) {
		itemlenbar_target_pos = ITEM_LENBAR_HIDDEN_POSITION;
	}
}

-(void)update_item_slot {
    [ingame_ui_item_slot set_item:[UserInventory get_current_gameitem]];
}

-(void)animslot_notification {
	item_slot_notify_anim_sc = 2;
}

@end
