#import "InventoryTabPane_Extras.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "InventoryLayerTabScrollList.h"
#import "MenuCommon.h"
#import "AudioManager.h"

typedef enum ExtrasPaneMode {
	ExtrasPaneMode_NONE,
	ExtrasPaneMode_ART,
	ExtrasPaneMode_MUSIC,
	ExtrasPaneMode_SFX
} ExtrasPaneMode;

@implementation InventoryTabPane_Extras {
	InventoryLayerTabScrollList *list;
	ExtrasPaneMode cur_mode;
	ExtrasPaneMode selected_mode;
	CCLabelBMFont *name_disp;
	CCLabelBMFont *desc_disp;
	
	TouchButton *categ_sel;
	TouchButton *categ_sel_back;
	
	TouchButton *action_button;
	CCLabelBMFont *action_button_label;
	
	NSString *action_select_id;
	
	NSMutableArray *touches;
}

+(InventoryTabPane_Extras*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Extras node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	touches = [NSMutableArray array];
	action_select_id = NULL;
	cur_mode = ExtrasPaneMode_NONE;
	selected_mode = ExtrasPaneMode_NONE;
	
	name_disp = [Common cons_bmlabel_pos:[Common pct_of_obj:parent pctx:0.4 pcty:0.88]
								 color:ccc3(205, 51, 51)
							  fontsize:24
								   str:@""];
	[name_disp setAnchorPoint:ccp(0,1)];
	[self addChild:name_disp];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
	desc_disp = [Common cons_bm_multiline_label_str:@""
											  width:actualSize.width
										  alignment:UITextAlignmentLeft
										   fontsize:13];
	[desc_disp setPosition:[Common pct_of_obj:parent pctx:0.4 pcty:0.7]];
	[desc_disp setAnchorPoint:ccp(0,1)];
	[desc_disp setColor:ccc3(0, 0, 0)];
	[self addChild:desc_disp];
	
	list = [InventoryLayerTabScrollList cons_parent:parent add_to:self];
	[self update_list];
	
	
	categ_sel =	[AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.9 pcty:0.15]
									  tex:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
								  texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeselectnextarrow"]
									   cb:[Common cons_callback:self sel:@selector(enter_category_select)]];
	[self addChild:categ_sel];
	[touches addObject:categ_sel];
	
	categ_sel_back =	[AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.4 pcty:0.15]
											     tex:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
											 texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeselectnextarrow"]
											      cb:[Common cons_callback:self sel:@selector(back_category_select)]];
	CCSprite *reversed_arrow = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
													  rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeselectnextarrow"]];
	[reversed_arrow setPosition:[Common pct_of_obj:categ_sel_back pctx:0.5 pcty:0.5]];
	[reversed_arrow setScaleX:-1];
	[categ_sel_back addChild:reversed_arrow];
	[self addChild:categ_sel_back];
	[touches addObject:categ_sel_back];
	
	action_button = [AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.85 pcty:0.15]
											 tex:[Resource get_tex:TEX_NMENU_ITEMS]
										 texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_shoptab"]
											  cb:[Common cons_callback:self sel:@selector(action_button_press)]];
	action_button_label = [Common cons_bmlabel_pos:[Common pct_of_obj:action_button pctx:0.5 pcty:0.5]
										   color:ccc3(0,0,0)
										fontsize:16
											 str:@""];
	[action_button addChild:action_button_label];
	[self addChild:action_button];
	[touches addObject:action_button];
	
	[self update_buttons];
	return self;
}

#define ADD_TAB(text,texid,selname) \
	[list add_tab:[Resource get_tex:TEX_NMENU_ITEMS] \
			 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:texid] \
		main_text:text sub_text:@"" \
		 callback:[Common cons_callback:self sel:@selector(selname)]]

#define ICON_MUSIC @"extrasicon_music"
#define ICON_ART @"extrasicon_art"
#define ICON_SFX @"extrasicon_sfx"

-(void)update_list {
	[list clear_tabs];
	if (cur_mode == ExtrasPaneMode_NONE) {
		ADD_TAB(@"Art", ICON_ART, category_select_art);
		ADD_TAB(@"Music", ICON_MUSIC, category_select_music);
		ADD_TAB(@"Sfx", ICON_SFX, category_select_sfx);
		
		[name_disp set_label:@"Extras"];
		[desc_disp set_label:@"Unlock concept art, music and sfx from the game and view them here!"];
		
	} else if (cur_mode == ExtrasPaneMode_ART) {
		ADD_TAB(@"Goober", ICON_ART, null_sel);
		ADD_TAB(@"Window", ICON_ART, null_sel);
		ADD_TAB(@"Pengmaku", ICON_ART, null_sel);
		ADD_TAB(@"MoeMoe", ICON_ART, null_sel);
		
	} else if (cur_mode == ExtrasPaneMode_MUSIC) {
		ADD_TAB(@"Menu", ICON_MUSIC, select_music_menu);
		ADD_TAB(@"Intro", ICON_MUSIC, select_music_intro);
		ADD_TAB(@"World1-1", ICON_MUSIC, select_music_world11);
		ADD_TAB(@"World1-2", ICON_MUSIC, select_music_world12);
		ADD_TAB(@"Lab", ICON_MUSIC, select_music_lab);
		ADD_TAB(@"Boss", ICON_MUSIC, select_music_boss);
		ADD_TAB(@"Sky World", ICON_MUSIC, select_music_skyworld);
		ADD_TAB(@"Jingle", ICON_MUSIC, selecT_music_jingle);
		ADD_TAB(@"World2-1", ICON_MUSIC, select_music_world21);
		ADD_TAB(@"World2-2", ICON_MUSIC, select_music_world22);
		ADD_TAB(@"World3-1", ICON_MUSIC, select_music_world31);
		ADD_TAB(@"World3-2", ICON_MUSIC, select_music_world32);
		ADD_TAB(@"Invincible", ICON_MUSIC, select_music_invincible);
		
	} else if (cur_mode == ExtrasPaneMode_SFX) {
		ADD_TAB(@"Happy", ICON_SFX, select_sfx_happy);
		ADD_TAB(@"Sad", ICON_SFX, select_sfx_lose);
		ADD_TAB(@"Checkpt", ICON_SFX, select_sfx_checkpt);
		ADD_TAB(@"Whimper", ICON_SFX, select_sfx_whimper);
		ADD_TAB(@"Bark1", ICON_SFX, select_sfx_bark1);
		ADD_TAB(@"Bark2", ICON_SFX, select_sfx_bark2);
		ADD_TAB(@"Bark3", ICON_SFX, select_sfx_bark3);
		ADD_TAB(@"Boss", ICON_SFX, select_sfx_boss);
		ADD_TAB(@"CatLaugh", ICON_SFX, select_sfx_catlaugh);
		ADD_TAB(@"CatHit", ICON_SFX, select_sfx_cathit);
		ADD_TAB(@"Cheer", ICON_SFX, select_sfx_cheer);
	}
	
	if ([list get_num_tabs] == 0) [desc_disp set_label:@"Unlock more extras from the store and wheel of prizes!"];
}

-(void)action_button_press {
	if (action_select_id != NULL) {
		if (cur_mode == ExtrasPaneMode_MUSIC) {
			[AudioManager playbgm_file:action_select_id];
		} else if (cur_mode == ExtrasPaneMode_SFX) {
			if (streq(action_select_id, SFX_FANFARE_WIN) || streq(action_select_id, SFX_FANFARE_LOSE)) {
				[AudioManager mute_music_for:10];
			} else {
				[AudioManager mute_music_for:4];
			}
			[AudioManager playsfx:action_select_id];
		}
	}
}

-(void)null_sel{}

-(void)select_sfx_happy{ [self select_sfx:SFX_FANFARE_WIN]; }
-(void)select_sfx_lose{ [self select_sfx:SFX_FANFARE_LOSE]; }
-(void)select_sfx_checkpt{ [self select_sfx:SFX_CHECKPOINT]; }
-(void)select_sfx_whimper{ [self select_sfx:SFX_WHIMPER]; }
-(void)select_sfx_bark1{ [self select_sfx:SFX_BARK_LOW]; }
-(void)select_sfx_bark2{ [self select_sfx:SFX_BARK_MID]; }
-(void)select_sfx_bark3{ [self select_sfx:SFX_BARK_HIGH]; }
-(void)select_sfx_boss{ [self select_sfx:SFX_BOSS_ENTER]; }
-(void)select_sfx_catlaugh{ [self select_sfx:SFX_CAT_LAUGH]; }
-(void)select_sfx_cathit{ [self select_sfx:SFX_CAT_HIT]; }
-(void)select_sfx_cheer{ [self select_sfx:SFX_CHEER]; }

-(void)select_music_menu{ [self select_music:BGMUSIC_MENU1]; }
-(void)select_music_intro{ [self select_music:BGMUSIC_INTRO]; }
-(void)select_music_world11{ [self select_music:BGMUSIC_GAMELOOP1]; }
-(void)select_music_world12{ [self select_music:BGMUSIC_GAMELOOP1_NIGHT]; }
-(void)select_music_lab{ [self select_music:BGMUSIC_LAB1]; }
-(void)select_music_boss{ [self select_music:BGMUSIC_BOSS1]; }
-(void)select_music_skyworld{ [self select_music:BGMUSIC_CAPEGAMELOOP]; }
-(void)selecT_music_jingle{ [self select_music:BGMUSIC_JINGLE]; }
-(void)select_music_world21{ [self select_music:BGMUSIC_GAMELOOP2]; }
-(void)select_music_world22{ [self select_music:BGMUSIC_GAMELOOP2_NIGHT]; }
-(void)select_music_world31{ [self select_music:BGMUSIC_GAMELOOP3]; }
-(void)select_music_world32{ [self select_music:BGMUSIC_GAMELOOP3_NIGHT]; }
-(void)select_music_invincible{ [self select_music:BGMUSIC_INVINCIBLE]; }

-(void)select_music:(NSString*)music_id {
	action_select_id =  music_id;
	[self update_buttons];
}

-(void)select_sfx:(NSString*)sfx_id {
	action_select_id = sfx_id;
	[self update_buttons];
}

-(void)update {
	if (!self.visible) return;
	[list update];
	for (id b in touches) if ([b respondsToSelector:@selector(update)]) [b update];
}

-(void)update_buttons {
	[categ_sel setVisible:cur_mode == ExtrasPaneMode_NONE && (selected_mode == ExtrasPaneMode_ART || selected_mode == ExtrasPaneMode_MUSIC || selected_mode == ExtrasPaneMode_SFX)];
	[categ_sel_back setVisible:(cur_mode == ExtrasPaneMode_ART || cur_mode == ExtrasPaneMode_MUSIC || cur_mode == ExtrasPaneMode_SFX)];
	[action_button setVisible:action_select_id != NULL];
	if ([action_button visible]) {
		if (cur_mode == ExtrasPaneMode_ART) {
			[action_button_label set_label:@"View!"];
		} else if (cur_mode == ExtrasPaneMode_MUSIC) {
			[action_button_label set_label:@"Play!"];
		} else if (cur_mode == ExtrasPaneMode_SFX) {
			[action_button_label set_label:@"Play!"];
		}
	}
}

-(void)back_category_select {
	if (cur_mode == ExtrasPaneMode_ART || cur_mode == ExtrasPaneMode_MUSIC || cur_mode == ExtrasPaneMode_SFX) {
		cur_mode = ExtrasPaneMode_NONE;
		selected_mode = ExtrasPaneMode_NONE;
		action_select_id = NULL;
		[self update_list];
	}
	[self update_buttons];
}

-(void)enter_category_select {
	if (selected_mode == ExtrasPaneMode_ART || selected_mode == ExtrasPaneMode_MUSIC || selected_mode == ExtrasPaneMode_SFX) {
		cur_mode = selected_mode;
		selected_mode = ExtrasPaneMode_NONE;
		action_select_id = NULL;
		[self update_list];
	}
	[self update_buttons];
}

-(void)category_select_art {
	selected_mode = ExtrasPaneMode_ART;
	[name_disp set_label:@"Art"];
	[desc_disp set_label:@"View concept art!"];
	[self update_buttons];
}

-(void)category_select_music {
	selected_mode = ExtrasPaneMode_MUSIC;
	[name_disp set_label:@"Music"];
	[desc_disp set_label:@"Listen to game music!"];
	[self update_buttons];
}

-(void)category_select_sfx {
	selected_mode = ExtrasPaneMode_SFX;
	[name_disp set_label:@"SFX"];
	[desc_disp set_label:@"Hear game sound effects!"];
	[self update_buttons];
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_begin:pt];
	for (TouchButton *b in touches) [b touch_begin:pt];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_move:pt];
	for (TouchButton *b in touches) [b touch_move:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_end:pt];
	for (TouchButton *b in touches) [b touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

-(void)dealloc {
	[list clear_tabs];
}

@end
