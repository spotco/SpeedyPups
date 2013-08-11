#import "MainMenuLayer.h"

@interface NMenuTabShopPage : NMenuPage <GEventListener> {
	NSMutableArray *touches;
}

+(NMenuTabShopPage*)cons;

@end
