#import <Foundation/Foundation.h>
@class TexRect;
@class CCTexture2D;
@class GameEngineLayer;

typedef enum {
    Item_NOITEM = 0,
    Item_Magnet = 1,
    Item_Rocket = 2,
    Item_Shield = 3,
    Item_Heart = 4,
	Item_Clock = 5
} GameItem;

@interface NSValue (valueWithGameItem)
+(NSValue*) valueWithGameItem:(GameItem)g;
@end

@implementation NSValue (valueWithETest)
+(NSValue*) valueWithGameItem:(GameItem)g {
    return [NSValue value:&g withObjCType: @encode(GameItem)];
}
@end

@interface GameItemCommon : NSObject
+(TexRect*)texrect_from:(GameItem)gameitem;
+(TexRect*)object_textrect_from:(GameItem)type;
+(NSString*)name_from:(GameItem)gameitem;
+(NSString*)description_from:(GameItem)gameitem;

+(void)use_item:(GameItem)it on:(GameEngineLayer*)g;
+(int)get_uselength_for:(GameItem)gi;

@end
