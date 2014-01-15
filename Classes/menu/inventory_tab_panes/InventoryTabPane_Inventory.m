#import "InventoryTabPane_Inventory.h"
#import "Common.h" 
#import "Resource.h"
#import "FileCache.h"
#import "ShopListTouchButton.h"
#import "ShopRecord.h"
#import "GameItemCommon.h"
#import "InventoryLayerTabScrollList.h"

@implementation InventoryTabPane_Inventory

+(InventoryTabPane_Inventory*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Inventory node] cons:parent];
}

-(id)cons:(CCSprite*)parent {
	
	list = [InventoryLayerTabScrollList cons_parent:parent add_to:self];
	
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
		main_text:[GameItemCommon name_from:Item_Rocket]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_shield)]];
	
	[list add_tab:[GameItemCommon texrect_from:Item_Rocket].tex
			 rect:[GameItemCommon texrect_from:Item_Rocket].rect
		main_text:[GameItemCommon name_from:Item_Rocket]
		 sub_text:@""
		 callback:[Common cons_callback:self sel:@selector(select_rocket)]];
	
	
	return self;
}

-(void)select_magnet {
	NSLog(@"magnet");
}

-(void)select_rocket {
	NSLog(@"rocket");
}

-(void)select_clock {
	NSLog(@"clock");
}

-(void)select_shield {
	NSLog(@"shield");
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
