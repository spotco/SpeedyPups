#import "MainMenuInventoryLayer.h"
@class InventoryLayerTabScrollList;

@interface InventoryTabPane_Upgrades : InventoryTabPane {
	InventoryLayerTabScrollList *list;
}

+(InventoryTabPane_Upgrades*)cons:(CCSprite*)parent;

@end
