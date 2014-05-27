#import "MainMenuInventoryLayer.h"
#import "GameItemCommon.h"
@class InventoryLayerTabScrollList;

@interface InventoryTabPane_Upgrades : InventoryTabPane {
	InventoryLayerTabScrollList *list;
	
	CCLabelBMFont *name_disp;
	CCLabelBMFont *desc_disp;
	
	CCSprite *upgrade_disp_bg;
	NSMutableArray *upgrade_stars;
	
	//CCLabelTTF *upgrade_disp;
	GameItem selected_item;
}

+(InventoryTabPane_Upgrades*)cons:(CCSprite*)parent;
-(void)update_labels_and_buttons;

@end
