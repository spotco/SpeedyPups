#import "cocos2d.h"
#import "GEventDispatcher.h"
@class MainSlotItemPane;

@interface MainMenuInventoryLayer : CCLayer <GEventListener> {
    CCSprite *inventory_window;
    NSArray *inventory_panes,*slot_panes;
    CCLabelTTF *bonectdsp, *infoname,*infodesc;
}

+(MainMenuInventoryLayer*)cons;

@end
