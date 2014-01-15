#import "MainMenuInventoryLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameItemCommon.h"
#import "Player.h"
#import "InventoryItemPane.h"
#import "AudioManager.h" 
#import "InventoryLayerTab.h"
#import "DataStore.h"
#import "WebRequest.h"

#import "AudioManager.h"

@implementation InventoryTabWindow
-(void)set_window_open:(BOOL)t{}
-(void)touch_begin:(CGPoint)pt{}
-(void)touch_move:(CGPoint)pt{}
-(void)touch_end:(CGPoint)pt{};
@end

@implementation MainMenuInventoryLayer

static NSString* default_text = @"Equip to use powerups on your next run. Unlock upgrades at the store!";
static NSString* locked_text = @"Buy at the store to unlock and equip on your next run!";

+(MainMenuInventoryLayer*)cons {
    return [MainMenuInventoryLayer node];
}

-(id)init {
    self = [super init];
    
    [GEventDispatcher add_listener:self];
	inventory_tab_items = [CCNode node];
	settings_tab_items = [CCNode node];
    
    inventory_window = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                              rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_inventorypane"]];
    [inventory_window setPosition:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:inventory_window];
	[inventory_window addChild:inventory_tab_items];
	[inventory_window addChild:settings_tab_items];
    
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                             rect:@"nmenu_closebutton"
                                              tar:self sel:@selector(close)
                                              pos:CGPointZero];
    [closebutton setPosition:[Common pct_of_obj:inventory_window pctx:0.975 pcty:0.95]];
	CCMenu *invmh = [CCMenu menuWithItems:closebutton, nil];
	[invmh setPosition:CGPointZero];
    [inventory_window addChild:invmh];
    [inventory_window setVisible:NO];
	
	[self cons_inventory_tab_items];
	[self cons_settings_tab_items];
	[inventory_tab_items setVisible:YES];
	[settings_tab_items setVisible:NO];
	
	tabs = [NSMutableArray array];
	CGPoint lefttab_pos = [Common pct_of_obj:inventory_window pctx:0 pcty:0.98];
	tab_inventory = [InventoryLayerTab cons_pt:ccp(lefttab_pos.x+1,lefttab_pos.y)
										  text:@"Inventory"
											cb:[Common cons_callback:self sel:@selector(tab_inventory)]];
	[tabs addObject:tab_inventory];
	[inventory_window addChild:tab_inventory];
	
	tab_upgrades = [InventoryLayerTab cons_pt:ccp(tab_inventory.position.x + tab_inventory.boundingBox.size.width,tab_inventory.position.y)
										 text:@"Upgrades"
										   cb:[Common cons_callback:self sel:@selector(tab_upgrades)]];
	[tabs addObject:tab_upgrades];
	[inventory_window addChild:tab_upgrades];
	
	tab_settings = [InventoryLayerTab cons_pt:ccp(tab_inventory.position.x + tab_inventory.boundingBox.size.width*2,tab_inventory.position.y)
										 text:@"Settings"
										   cb:[Common cons_callback:self sel:@selector(tab_settings)]];
	[tabs addObject:tab_settings];
	[inventory_window addChild:tab_settings];
	
	tab_extras = [InventoryLayerTab cons_pt:ccp(tab_inventory.position.x + tab_inventory.boundingBox.size.width*3,tab_inventory.position.y)
										 text:@"Extras"
										   cb:[Common cons_callback:self sel:@selector(tab_extras)]];
	[tabs addObject:tab_extras];
	[inventory_window addChild:tab_extras];
	
	[tab_inventory set_selected:YES];
	[tab_settings set_selected:NO];
	
	
    return self;
}

-(void)tab_inventory {
	[tab_settings set_selected:NO];
	[tab_inventory set_selected:YES];
	[inventory_tab_items setVisible:YES];
	[settings_tab_items setVisible:NO];
	[AudioManager playsfx:SFX_MENU_UP];
}

-(void)tab_settings {
	[tab_inventory set_selected:NO];
	[tab_settings set_selected:YES];
	[inventory_tab_items setVisible:NO];
	[settings_tab_items setVisible:YES];
	[AudioManager playsfx:SFX_MENU_UP];
}

-(void)tab_upgrades {
	
}

-(void)tab_extras {
	
}

-(void)cons_inventory_tab_items {
    CCMenu *itempanes = [CCMenu menuWithItems:nil];
	[itempanes setPosition:[Common pct_of_obj:inventory_window pctx:0.55 pcty:0.7]];
    
	float panewid = [InventoryItemPane invpane_size].size.width;
    SEL invpanesel[] = {@selector(invpane1_click),@selector(invpane2_click),@selector(invpane3_click),@selector(invpane4_click)};
    GameItem defaultpaneitem[] = {Item_Magnet,Item_Rocket,Item_Clock,Item_Shield};
    NSMutableArray *itempanesarr = [NSMutableArray array];
    for(int i = 0; i < 4; i++) {
        InventoryItemPane *ip = [InventoryItemPane cons_pt:ccp(-panewid*1.75+(panewid+5)*i,0)
                                                        cb:[Common cons_callback:self sel:invpanesel[i]]];
        [itempanes addChild:ip];
        [ip set_item:defaultpaneitem[i]];
        [itempanesarr addObject:ip];
    }
    [inventory_tab_items addChild:itempanes];
    inventory_panes = itempanesarr;
    
	
    CCSprite *divider = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"inventorydivider"]];
    [divider setPosition:[Common pct_of_obj:inventory_window pctx:0.5 pcty:0.475]];
    [inventory_tab_items addChild:divider];
    
    CCSprite *player = [CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]] rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"run_0"]];
    [player setScale:0.8];
    [player setPosition:[Common pct_of_obj:inventory_window pctx:0.7 pcty:0.3]];
    [inventory_tab_items addChild:player];
    
    CCSprite *boneicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tinybone"]];
    [boneicon setPosition:[Common pct_of_obj:inventory_window pctx:0.665 pcty:0.15]];
    [inventory_tab_items addChild:boneicon];
    bonectdsp = [Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.695 pcty:0.15] color:ccc3(0, 0, 0) fontsize:15 str:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    [bonectdsp setAnchorPoint:ccp(0,0.5)];
    [inventory_tab_items addChild:bonectdsp];
    
	mainslot = [MainSlotItemPane cons_pt:[Common pct_of_obj:inventory_window pctx:0.87 pcty:0.24]
									  cb:[Common cons_callback:self sel:@selector(slotpane0_click)]
									slot:0];
	[inventory_tab_items addChild:[Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.87 pcty:0.4]
												color:ccc3(200,30,30)
											 fontsize:13
												  str:@"Equipped:"]];
    CCMenu *slotitems = [CCMenu menuWithItems:mainslot,NULL];
	[slotitems setPosition:CGPointZero];
	[inventory_tab_items addChild:slotitems];
	
	
    infoname = [Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.075 pcty:0.375]
								color:ccc3(205, 51, 51)
							 fontsize:20
								  str:@""];
    [infoname setAnchorPoint:ccp(0,0.5)];
    [inventory_tab_items addChild:infoname];
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:UILineBreakModeWordWrap];
    
    infodesc = [CCLabelTTF labelWithString:default_text
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:15];
    [infodesc setColor:ccc3(0,0,0)];
    [infodesc setAnchorPoint:ccp(0,0.5)];
    [infodesc setPosition:[Common pct_of_obj:inventory_window pctx:0.075 pcty:0.215]];
    [inventory_tab_items addChild:infodesc];
    
    [self update_invpane];
	pane_anim_scale = 1;
}

-(void)cons_settings_tab_items {
	settings_touches = [NSMutableArray array];
	
	PollingButton *playbgmb = [PollingButton cons_pt:[Common pct_of_obj:inventory_window pctx:0.125 pcty:0.8]
									   texkey:TEX_NMENU_ITEMS
									   yeskey:@"nmenu_checkbutton"
										nokey:@"nmenu_xbutton"
										 poll:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(get_play_bgm)]
										click:[Common cons_callback:self sel:@selector(toggle_play_bgm)]];
	[settings_tab_items addChild:playbgmb];
	[settings_touches addObject:playbgmb];
	[settings_tab_items addChild:[[Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.2 pcty:0.8]
												  color:ccc3(0,0,0)
											   fontsize:16
													str:@"play music"] anchor_pt:ccp(0,0.5)]];
	
	PollingButton *playsfxb = [PollingButton cons_pt:[Common pct_of_obj:inventory_window pctx:0.125 pcty:0.55]
											  texkey:TEX_NMENU_ITEMS
											  yeskey:@"nmenu_checkbutton"
											   nokey:@"nmenu_xbutton"
												poll:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(get_play_sfx)]
											   click:[Common cons_callback:self sel:@selector(toggle_play_sfx)]];
	[settings_tab_items addChild:playsfxb];
	[settings_touches addObject:playsfxb];
	[settings_tab_items addChild:[[Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.2 pcty:0.55]
												  color:ccc3(0,0,0)
											   fontsize:16
													str:@"play sfx"] anchor_pt:ccp(0,0.5)]];
	
	TouchButton *cleardata = [AnimatedTouchButton cons_pt:[Common pct_of_obj:inventory_window pctx:0.16 pcty:0.25]
													  tex:[Resource get_tex:TEX_NMENU_ITEMS]
												  texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_shoptab"]
													   cb:[Common cons_callback:self sel:@selector(clear_data)]];
	[cleardata addChild:[Common cons_label_pos:[Common pct_of_obj:cleardata pctx:0.5 pcty:0.5]
										 color:ccc3(0,0,0)
									  fontsize:13
										   str:@"Reset Data"]];
	[settings_tab_items addChild:cleardata];
	[settings_touches addObject:cleardata];
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
	[tab_inventory update];
	[tab_settings update];
	if (settings_tab_items.visible) {
		for (TouchButton *b in settings_touches) if ([b respondsToSelector:@selector(update)]) [b performSelector:@selector(update)];
	}
}

-(void)update_invpane {
    [bonectdsp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    [mainslot set_item:[UserInventory get_current_gameitem]];
	for (InventoryItemPane *i in inventory_panes) {
		[i set_item:[i cur_item]];
	}
}

-(void)invpane1_click {[self invpane_click:0];}
-(void)invpane2_click {[self invpane_click:1];}
-(void)invpane3_click {[self invpane_click:2];}
-(void)invpane4_click {[self invpane_click:3];}

-(void)slotpane0_click {
	[UserInventory set_current_gameitem:Item_NOITEM];
	[UserInventory set_equipped_gameitem:Item_NOITEM];
	[self update_invpane];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

-(void)invpane_click:(int)i {
    GameItem t = [(InventoryItemPane*)[inventory_panes objectAtIndex:i] cur_item];
	if ([UserInventory get_upgrade_level:t] == 0) {
		[infodesc setString:locked_text];
	} else {
		[infodesc setString:[GameItemCommon description_from:t]];
	}
	
	
    if ([UserInventory get_upgrade_level:t] > 0) {
		[UserInventory set_equipped_gameitem:t];
		[UserInventory set_current_gameitem:t];
		pane_anim_scale = 2;
		[infoname setString:[NSString stringWithFormat:@"%@ (%@)",[GameItemCommon name_from:t],[GameItemCommon stars_for_level:[UserInventory get_upgrade_level:t]]]];
		[AudioManager playsfx:SFX_MENU_UP];
	
	} else {
		[infoname setString:[NSString stringWithFormat:@"%@ (%@)",[GameItemCommon name_from:t],[GameItemCommon stars_for_level:[UserInventory get_upgrade_level:t]]]];
	}
	
    [self update_invpane];
}

-(void)open {
    [inventory_window setVisible:YES];
	[self update_invpane];
	
	[infoname setString:@"Powerups"];
	[infodesc setString:default_text];
	
	[AudioManager playsfx:SFX_MENU_UP];
}

-(void)close {
    [GEventDispatcher push_event:[GEvent cons_type:GEVentType_MENU_CLOSE_INVENTORY]];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [self open];
		
    } else if (e.type == GeventType_MENU_UPDATE_INVENTORY) {
		[self update_invpane];
		
	} else if (e.type == GEventType_MENU_TICK) {
		pane_anim_scale = pane_anim_scale - (pane_anim_scale-1)/3;
		[mainslot setScale:pane_anim_scale];
		[self update];
		
	} else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
		[inventory_window setVisible:NO];
	}
}

-(BOOL)window_open {
	return inventory_window.visible;
}

-(void)touch_begin:(CGPoint)pt {
	for (int i = tabs.count-1; i>=0; i--) {
		TouchButton *b = tabs[i];
		[b touch_begin:pt];
	}
	if (settings_tab_items.visible) {
		for (int i = settings_touches.count-1; i>=0; i--) {
			TouchButton *b = settings_touches[i];
			[b touch_begin:pt];
		}
	}
}
-(void)touch_move:(CGPoint)pt{}
-(void)touch_end:(CGPoint)pt{
	for (int i = tabs.count-1; i>=0; i--) {
		TouchButton *b = tabs[i];
		[b touch_end:pt];
	}
	if (settings_tab_items.visible) {
		for (int i = settings_touches.count-1; i>=0; i--) {
			TouchButton *b = settings_touches[i];
			[b touch_end:pt];
		}
	}
}



@end
