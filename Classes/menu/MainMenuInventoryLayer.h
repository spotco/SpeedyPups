#import "cocos2d.h"
#import "GEventDispatcher.h"
@class MainSlotItemPane;

@interface MainMenuInventoryLayer : CCLayer <GEventListener> {
    CCSprite *inventory_window;
    NSArray *inventory_panes;
    CCLabelTTF *bonectdsp, *infoname,*infodesc;

	MainSlotItemPane *mainslot;
	
	float pane_anim_scale;
}

+(MainMenuInventoryLayer*)cons;

@end
