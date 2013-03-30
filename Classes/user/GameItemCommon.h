#import <Foundation/Foundation.h>
@class CCTexture2D;

typedef enum {
    Item_NOITEM = 0,
    Item_Magnet = 1,
    Item_Rocket = 2,
    Item_Shield = 3,
    Item_Heart = 4
} GameItem;

@interface TexRect : NSObject
@property(readwrite,strong) CCTexture2D* tex;
@property(readwrite,assign) CGRect rect;
+(TexRect*)cons_tex:(CCTexture2D*)tex rect:(CGRect)rect;
@end

@interface GameItemCommon : NSObject
+(TexRect*)texrect_from:(GameItem)gameitem;
+(NSString*)name_from:(GameItem)gameitem;
+(NSString*)description_from:(GameItem)gameitem;
@end
