#import "InventoryTabPane_Settings.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "AudioManager.h"
#import "InventoryLayerTab.h"
#import "DataStore.h"
#import "Player.h"

@implementation InventoryTabPane_Settings

+(InventoryTabPane_Settings*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Settings node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	touches = [NSMutableArray array];
	
	PollingButton *playbgmb = [PollingButton cons_pt:[Common pct_of_obj:parent pctx:0.125 pcty:0.8]
											  texkey:TEX_NMENU_ITEMS
											  yeskey:@"nmenu_checkbutton"
											   nokey:@"nmenu_xbutton"
												poll:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(get_play_bgm)]
											   click:[Common cons_callback:self sel:@selector(toggle_play_bgm)]];
	[self addChild:playbgmb];
	[touches addObject:playbgmb];
	
	[self addChild:[[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.2 pcty:0.8]
												   color:ccc3(0,0,0)
												fontsize:16
													 str:@"play music"] anchor_pt:ccp(0,0.5)]];
	
	PollingButton *playsfxb = [PollingButton cons_pt:[Common pct_of_obj:parent pctx:0.125 pcty:0.55]
											  texkey:TEX_NMENU_ITEMS
											  yeskey:@"nmenu_checkbutton"
											   nokey:@"nmenu_xbutton"
												poll:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(get_play_sfx)]
											   click:[Common cons_callback:self sel:@selector(toggle_play_sfx)]];
	[self addChild:playsfxb];
	[touches addObject:playsfxb];
	[self addChild:[[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.2 pcty:0.55]
												   color:ccc3(0,0,0)
												fontsize:16
													 str:@"play sfx"] anchor_pt:ccp(0,0.5)]];
	
	TouchButton *cleardata = [AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.16 pcty:0.25]
													  tex:[Resource get_tex:TEX_NMENU_ITEMS]
												  texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_shoptab"]
													   cb:[Common cons_callback:self sel:@selector(clear_data)]];
	[cleardata addChild:[Common cons_label_pos:[Common pct_of_obj:cleardata pctx:0.5 pcty:0.5]
										 color:ccc3(0,0,0)
									  fontsize:13
										   str:@"Reset Data"]];
	[self addChild:cleardata];
	[touches addObject:cleardata];
	return self;
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

-(void)toggle_play_bgm {
	[AudioManager set_play_bgm:![AudioManager get_play_bgm]];
	[AudioManager playbgm_imm:BGM_GROUP_MENU];
	
}

-(void)toggle_play_sfx {
	[AudioManager set_play_sfx:![AudioManager get_play_sfx]];
	[AudioManager playsfx:SFX_MENU_UP];
}

-(void)clear_data {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
													message:@""
												   delegate:self
										  cancelButtonTitle:@"Yes"
										  otherButtonTitles:@"No",nil];
	[alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[DataStore reset_all];
		[Player set_character:TEX_DOG_RUN_1];
		[GEventDispatcher immediate_event:[GEvent cons_type:GEventType_QUIT]];
	}
}

-(void)update {
	if (!self.visible) return;
	for (id obj in self.children) {
		if ([obj respondsToSelector:@selector(update)]) {
			[obj update];
		}
	}
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) [b touch_begin:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) [b touch_end:pt];
}

@end
