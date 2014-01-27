#import "InventoryTabPane_Extras.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"

@implementation InventoryTabPane_Extras

+(InventoryTabPane_Extras*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Extras node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	[self addChild:[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.5 pcty:0.5]
									color:ccc3(10,10,10)
								 fontsize:15
									  str:@"Extras (Coming soon!)"]];
	return self;
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end