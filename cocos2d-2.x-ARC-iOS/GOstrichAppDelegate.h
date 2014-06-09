#import <UIKit/UIKit.h>
#import "GameMain.h"

@class RootViewController;

@interface GOstrichAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
+(GOstrichAppDelegate*)instance;
-(RootViewController*)get_view_controller;
@end
