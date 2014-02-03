#import "InventoryTabPane_Inventory.h"
#import "Common.h" 
#import "Resource.h"
#import "FileCache.h"
#import "ShopListTouchButton.h"
#import "ShopRecord.h"
#import "InventoryLayerTabScrollList.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "AudioManager.h"

@implementation InventoryTabPane_Inventory

+(InventoryTabPane_Inventory*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Inventory node] cons:parent];
}

-(id)cons:(CCSprite*)parent {
	
	list = [InventoryLayerTabScrollList cons_parent:parent add_to:self];
	touches = [NSMutableArray array];
	
	added_items = [NSMutableDictionary dictionary];
	[self update_available_items];
	
	name_disp = [Common cons_label_pos:[Common pct_of_obj:parent pctx:0.4 pcty:0.88]
								 color:ccc3(205, 51, 51)
							  fontsize:20
								   str:@"Inventory"];
	[name_disp setAnchorPoint:ccp(0,1)];
	[self addChild:name_disp];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
	desc_disp = [CCLabelTTF labelWithString:@"You'll find items you collect here.\nCheck out the store to buy stuff!"
								 dimensions:actualSize
								  alignment:UITextAlignmentLeft
								   fontName:@"Carton Six"
								   fontSize:15];
	[desc_disp setPosition:[Common pct_of_obj:parent pctx:0.4 pcty:0.7]];
	[desc_disp setAnchorPoint:ccp(0,1)];
	[desc_disp setColor:ccc3(0, 0, 0)];
	[self addChild:desc_disp];
	
	equip_button = [AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.875 pcty:0.125]
													  tex:[Resource get_tex:TEX_NMENU_ITEMS]
												  texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_shoptab"]
													   cb:[Common cons_callback:self sel:@selector(equip_button_press)]];
	
	[equip_button addChild:[Common cons_label_pos:[Common pct_of_obj:equip_button pctx:0.5 pcty:0.5]
										 color:ccc3(0,0,0)
									  fontsize:18
										   str:@"Equip"]];
	[self addChild:equip_button];
	[touches addObject:equip_button];
	[equip_button setVisible:NO];
	
	equipped_label = [Common cons_label_pos:[Common pct_of_obj:parent pctx:0.875 pcty:0.125]
									  color:ccc3(205, 51, 51)
								   fontsize:18
										str:@"Equipped"];
	[self addChild:equipped_label];
	[equipped_label setVisible:NO];
	
	selected_item = Item_NOITEM;
	
	return self;
}

#define added_items_contains(x) ([added_items objectForKey:x] != NULL)
#define added_items_add(x) [added_items setObject:@1 forKey:x]
-(void)update_available_items {
	
	NSString *bones = @"Bones";
	if (!added_items_contains(bones)) {
		bones_button = [list add_tab:[Resource get_tex:TEX_NMENU_ITEMS]
				 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]
			main_text:bones
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_bones)]];
		
		added_items_add(bones);
	}
	
	NSString *coins = @"Coins";
	if (!added_items_contains(coins)) {
		coins_button = [list add_tab:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
				 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeicon_coin"]
			main_text:coins
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_coins)]];
		added_items_add(coins);
	}
	
	//TODO -- the conditions should be changed
	if (!added_items_contains([GameItemCommon name_from:Item_Magnet]) && [UserInventory get_upgrade_level:Item_Magnet] > 0) {
		[list add_tab:[GameItemCommon texrect_from:Item_Magnet].tex
				 rect:[GameItemCommon texrect_from:Item_Magnet].rect
			main_text:[GameItemCommon name_from:Item_Magnet]
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_magnet)]];
		
		added_items_add([GameItemCommon name_from:Item_Magnet]);
	}
	
	if (!added_items_contains([GameItemCommon name_from:Item_Rocket]) && [UserInventory get_upgrade_level:Item_Rocket] > 0) {
		[list add_tab:[GameItemCommon texrect_from:Item_Rocket].tex
				 rect:[GameItemCommon texrect_from:Item_Rocket].rect
			main_text:[GameItemCommon name_from:Item_Rocket]
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_rocket)]];
		
		added_items_add([GameItemCommon name_from:Item_Rocket]);
	}
	
	if (!added_items_contains([GameItemCommon name_from:Item_Clock]) && [UserInventory get_upgrade_level:Item_Clock] > 0) {
		[list add_tab:[GameItemCommon texrect_from:Item_Clock].tex
				 rect:[GameItemCommon texrect_from:Item_Clock].rect
			main_text:[GameItemCommon name_from:Item_Clock]
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_clock)]];
		
		added_items_add([GameItemCommon name_from:Item_Clock]);
	}
	
	if (!added_items_contains([GameItemCommon name_from:Item_Shield]) && [UserInventory get_upgrade_level:Item_Shield] > 0) {
		[list add_tab:[GameItemCommon texrect_from:Item_Shield].tex
				 rect:[GameItemCommon texrect_from:Item_Shield].rect
			main_text:[GameItemCommon name_from:Item_Shield]
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(select_shield)]];
		
		added_items_add([GameItemCommon name_from:Item_Shield]);
	}
	
	[self update_labels_and_buttons];
}

-(void)equip_button_press {
	if (selected_item != Item_NOITEM) {
		[UserInventory set_equipped_gameitem:selected_item];
		[AudioManager playsfx:SFX_MENU_UP];
	}
	[self update_labels_and_buttons];
}

-(void)select_bones {
	selected_item = Item_NOITEM;
	[self update_labels_and_buttons];
	[name_disp setString:@"Bones"];
	[desc_disp setString:@"Common currency you'll find find in the game. Buy things at the store with this!"];
}

-(void)select_coins {
	selected_item = Item_NOITEM;
	[self update_labels_and_buttons];
	[name_disp setString:@"Coins"];
	[desc_disp setString:@"A rare currency you'll occasionally find in the game. Use this to unlock characters!"];
}

-(void)select_magnet {
	selected_item = Item_Magnet;
	[self update_labels_and_buttons];
}

-(void)select_rocket {
	selected_item = Item_Rocket;
	[self update_labels_and_buttons];
}

-(void)select_clock {
	selected_item = Item_Clock;
	[self update_labels_and_buttons];
}

-(void)select_shield {
	selected_item = Item_Shield;
	[self update_labels_and_buttons];
}

-(void)update_labels_and_buttons {
	if (selected_item != Item_NOITEM) {
		if (selected_item == [UserInventory get_equipped_gameitem]) {
			[equip_button setVisible:NO];
			[equipped_label setVisible:YES];
		} else {
			[equip_button setVisible:YES];
			[equipped_label setVisible:NO];
		}
		[name_disp setString:[GameItemCommon name_from:selected_item]];
		[desc_disp setString:[GameItemCommon description_from:selected_item]];
		
	} else {
		[equip_button setVisible:NO];
		[equipped_label setVisible:NO];
	}
	
	[bones_button set_sub_text:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
	[coins_button set_sub_text:[NSString stringWithFormat:@"%d",0]];
	
}

-(void)update {
	if (!self.visible) return;
	[list update];
	for (id obj in touches) {
		if ([obj respondsToSelector:@selector(update)]) {
			[obj update];
		}
	}
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_begin:pt];
	for (TouchButton *b in touches) [b touch_begin:pt];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_move:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_end:pt];
	for (TouchButton *b in touches) [b touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
