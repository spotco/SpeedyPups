#import "MainMenuLayer.h"
@class ShopManager;

@interface NMenuShopPage : NMenuPage <GEventListener> {
    CCMenu *controlm;
	ShopManager *shop;
}
+(NMenuShopPage*)cons;
@end
