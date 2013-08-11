#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Resource.h"
#import "FileCache.h"

@interface TouchButton : CCSprite

+(TouchButton*)cons_pt:(CGPoint)pt tex:(CCTexture2D*)tex texrect:(CGRect)texrect cb:(CallBack*)tcb;
-(void)touch_begin:(CGPoint)pt;
@property(readwrite,assign) CGRect touchrect;
@property(readwrite,strong) CallBack* cb;
@end

@interface MenuCommon : NSObject

+(CCSprite*)menu_item:(NSString*)tex id:(NSString*)tid pos:(CGPoint)pos;
+(CCMenuItem*)item_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos;
+(CCMenu*)cons_common_nav_menu;

+(CCMenuItem*)nav_menu_get_charselbutton:(CCMenu*)menu;

@end
