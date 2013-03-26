#import "CCLayer.h"
#import "Resource.h"
#import "AudioManager.h"
#import "Common.h"
#import "GEventDispatcher.h"
#import "MainMenuBGLayer.h"


#define MENU_STARTING_PAGE_ID 2
#define MENU_DOG_MODE_PAGE_ID 1
#define MENU_SETTINGS_PAGE_ID 3
#define MENU_SHOP_PAGE 0

@interface NMenuPage : CCSprite
@end

@interface MainMenuLayer : CCLayer <GEventListener> {
    NSMutableArray* menu_pages;
    int cur_page;
    CGPoint last,dp;
}

@property(readwrite,strong) MainMenuBGLayer* bg;

+(CCScene*)scene;

@end