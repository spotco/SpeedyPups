#import "InventoryTabPane_Upgrades.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "InventoryLayerTabScrollList.h"
#import "GameItemCommon.h"
#import "UserInventory.h"

@implementation InventoryTabPane_Upgrades

+(InventoryTabPane_Upgrades*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Upgrades node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	list = [InventoryLayerTabScrollList cons_parent:parent add_to:self];
	
	name_disp = [Common cons_label_pos:[Common pct_of_obj:parent pctx:0.4 pcty:0.88]
								 color:ccc3(205, 51, 51)
							  fontsize:20
								   str:@"Upgrades"];
	[name_disp setAnchorPoint:ccp(0,1)];
	[self addChild:name_disp];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
	desc_disp = [CCLabelTTF labelWithString:@"Keep track of your upgrades to powerups here!"
								 dimensions:actualSize
								  alignment:UITextAlignmentLeft
								   fontName:@"Carton Six"
								   fontSize:15];
	[desc_disp setPosition:[Common pct_of_obj:parent pctx:0.4 pcty:0.7]];
	[desc_disp setAnchorPoint:ccp(0,1)];
	[desc_disp setColor:ccc3(0, 0, 0)];
	[self addChild:desc_disp];
	
	upgrade_disp = [Common cons_label_pos:[Common pct_of_obj:parent pctx:0.4 pcty:0.3]
									color:ccc3(0,0,0)
								 fontsize:30
									  str:@""];
	[upgrade_disp setAnchorPoint:ccp(0,1)];
	[self addChild:upgrade_disp];
	
	selected_item = Item_NOITEM;
	
	[list add_tab:[GameItemCommon texrect_from:Item_Magnet].tex
			 rect:[GameItemCommon texrect_from:Item_Magnet].rect
		main_text:[GameItemCommon name_from:Item_Magnet]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_magnet)]];
	
	[list add_tab:[GameItemCommon texrect_from:Item_Rocket].tex
			 rect:[GameItemCommon texrect_from:Item_Rocket].rect
		main_text:[GameItemCommon name_from:Item_Rocket]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_rocket)]];
	
	[list add_tab:[GameItemCommon texrect_from:Item_Clock].tex
			 rect:[GameItemCommon texrect_from:Item_Clock].rect
		main_text:[GameItemCommon name_from:Item_Clock]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_clock)]];
	
	[list add_tab:[GameItemCommon texrect_from:Item_Shield].tex
			 rect:[GameItemCommon texrect_from:Item_Shield].rect
		main_text:[GameItemCommon name_from:Item_Shield]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_shield)]];
	
	return self;
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
		[name_disp setString:[GameItemCommon name_from:selected_item]];
		[desc_disp setString:[GameItemCommon description_from:selected_item]];
		[upgrade_disp setString:[GameItemCommon stars_for_level:[UserInventory get_upgrade_level:selected_item]]];
	}
}

-(void)update {
	if (!self.visible) return;
	[list update];
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_begin:pt];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_move:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
