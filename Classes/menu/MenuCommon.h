#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Resource.h"
#import "FileCache.h"

@interface MenuCommon : NSObject

+(CCSprite*)menu_item:(NSString*)tex id:(NSString*)tid pos:(CGPoint)pos;
+(CCMenuItem*)item_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos;
+(CCMenu*)cons_common_nav_menu;

+(CCMenuItem*)nav_menu_get_charselbutton:(CCMenu*)menu;

@end
