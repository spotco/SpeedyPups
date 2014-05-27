#import "MainMenuInventoryLayer.h"

@interface InventoryTabPane_Settings : InventoryTabPane {
	NSMutableArray *touches;
	CCLabelBMFont *version;
}

+(InventoryTabPane_Settings*)cons:(CCSprite*)parent;

@end
