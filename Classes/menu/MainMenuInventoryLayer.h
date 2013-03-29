#import "cocos2d.h"
#import "GEventDispatcher.h"

@interface MainMenuInventoryLayer : CCLayer <GEventListener> {
    CCSprite *inventory_window;
}

+(MainMenuInventoryLayer*)cons;

@end
