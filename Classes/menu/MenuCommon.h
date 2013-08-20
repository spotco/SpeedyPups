#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Resource.h"
#import "FileCache.h"

@interface TouchButton : CCSprite

+(TouchButton*)cons_pt:(CGPoint)pt tex:(CCTexture2D*)tex texrect:(CGRect)texrect cb:(CallBack*)tcb;
-(id)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect cb:(CallBack *)tcb;
-(void)touch_begin:(CGPoint)pt;
-(void)touch_move:(CGPoint)pt;
-(void)touch_end:(CGPoint)pt;
-(CGRect)hit_rect_local;
@property(readwrite,strong) CallBack* cb;
@end

@interface LabelGroup : NSObject {
	NSMutableArray *labels;
}
-(LabelGroup*)add_label:(CCLabelTTF*)l;
-(void)set_string:(NSString*)string;
@end

@interface MenuCommon : NSObject

+(CCSprite*)menu_item:(NSString*)tex id:(NSString*)tid pos:(CGPoint)pos;
+(CCMenuItem*)item_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos;
+(CCMenu*)cons_common_nav_menu;

+(CCMenuItem*)nav_menu_get_charselbutton:(CCMenu*)menu;
+(void)inventory;
+(void)goto_shop;
+(void)goto_charsel;
+(void)goto_home;
+(void)goto_settings;
+(void)close_inventory;

@end
