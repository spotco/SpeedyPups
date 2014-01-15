#import "InventoryTabPane_Inventory.h"
#import "Common.h" 
#import "Resource.h"
#import "FileCache.h"

@implementation InventoryTabPane_Inventory

+(InventoryTabPane_Inventory*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Inventory node] cons:parent];
}

-(id)cons:(CCSprite*)parent {
	[self addChild:[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.5 pcty:0.5]
									color:ccc3(10,10,10)
								 fontsize:15
									  str:@"Inventory"]];
	return self;
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
