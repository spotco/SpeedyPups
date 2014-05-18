#import "MainMenuInventoryLayer.h"

@interface InventoryTabPane_Settings : InventoryTabPane {
	NSMutableArray *touches;
	CCLabelTTF *version;
}

+(InventoryTabPane_Settings*)cons:(CCSprite*)parent;

@end
