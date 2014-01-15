#import "MainMenuInventoryLayer.h"
@class InventoryLayerTabScrollList;

@interface InventoryTabPane_Inventory : InventoryTabPane {
	InventoryLayerTabScrollList *list;
}

+(InventoryTabPane_Inventory*)cons:(CCSprite*)parent;

@end
