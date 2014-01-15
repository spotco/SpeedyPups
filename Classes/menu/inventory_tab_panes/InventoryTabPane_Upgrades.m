#import "InventoryTabPane_Upgrades.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"

@implementation InventoryTabPane_Upgrades

+(InventoryTabPane_Upgrades*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Upgrades node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	[self addChild:[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.5 pcty:0.5]
									color:ccc3(10,10,10)
								 fontsize:15
									  str:@"Upgrades"]];
	return self;
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
