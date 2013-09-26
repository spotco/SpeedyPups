#import "cocos2d.h"
#import "GEventDispatcher.h"
@class MainSlotItemPane;
@class InventoryLayerTab;

@interface MainMenuInventoryLayer : CCLayer <GEventListener> {
    CCSprite *inventory_window;
	
	CCNode *inventory_tab_items;
	CCNode *settings_tab_items;
	
	NSMutableArray *tabs;
	InventoryLayerTab *tab_inventory;
	InventoryLayerTab *tab_settings;
	
	//old inventory tab stuff, uses ccmenu
    NSArray *inventory_panes;
    CCLabelTTF *bonectdsp, *infoname,*infodesc;
	MainSlotItemPane *mainslot;
	float pane_anim_scale;
	
	//settings tab stuff
	NSMutableArray *settings_touches;
}

+(MainMenuInventoryLayer*)cons;

-(BOOL)window_open;

-(void)touch_begin:(CGPoint)pt;
-(void)touch_move:(CGPoint)pt;
-(void)touch_end:(CGPoint)pt;

@end
