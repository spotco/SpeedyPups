#import "InventoryTabPane_Upgrades.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "InventoryLayerTabScrollList.h"
#import "GameItemCommon.h"

@implementation InventoryTabPane_Upgrades

+(InventoryTabPane_Upgrades*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Upgrades node] cons:parent];
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
		 callback:[Common cons_callback:self sel:@selector(select_magnet)]];
	
	return self;
}

-(void)select_magnet {
	NSLog(@"upgrade magnet");
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
