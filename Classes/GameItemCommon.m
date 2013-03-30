#import "Resource.h"
#import "FileCache.h"
#import "GameItemCommon.h"

@interface NSValue (valueWithGameItem)
+(NSValue*) valueWithGameItem:(GameItem)g;
@end

@implementation NSValue (valueWithETest)
+(NSValue*) valueWithGameItem:(GameItem)g {
    return [NSValue value:&g withObjCType: @encode(GameItem)];
}
@end

@implementation TexRect
@synthesize tex;
@synthesize rect;
+(TexRect*)cons_tex:(CCTexture2D *)tex rect:(CGRect)rect {
    TexRect *r = [[TexRect alloc] init]; [r setTex:tex]; [r setRect:rect]; return r;
}
@end


@implementation GameItemCommon

static NSDictionary* names;
static NSDictionary* descriptions;

+(void)initialize {
    names = @{
        [NSValue valueWithGameItem:Item_Heart]: @"Extra Heart",
        [NSValue valueWithGameItem:Item_Magnet]: @"Magnet",
        [NSValue valueWithGameItem:Item_Rocket]: @"Rocket",
        [NSValue valueWithGameItem:Item_Shield]: @"Shield"
    };
    
    descriptions = @{
        [NSValue valueWithGameItem:Item_Heart]: @"Carry it to take an extra hit from any obstable.",
        [NSValue valueWithGameItem:Item_Magnet]: @"Bones and other goodies will come your way!",
        [NSValue valueWithGameItem:Item_Rocket]: @"Zoom past your troubles!",
        [NSValue valueWithGameItem:Item_Shield]: @"Brief invincibility. Run past anything!"
    };
}

+(TexRect*)texrect_from:(GameItem)gameitem {
    CCTexture2D* tex = [Resource get_tex:TEX_ITEM_SS];
    if (gameitem == Item_Magnet) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_magnet"]];
    if (gameitem == Item_Rocket) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_rocket"]];
    if (gameitem == Item_Shield) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_shield"]];
    if (gameitem == Item_Heart) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_heart"]];
    if (gameitem == Item_NOITEM) return [TexRect cons_tex:tex rect:CGRectZero];
    [NSException raise:@"unknown gameitem" format:@"%d",gameitem];
    return NULL;
}


+(NSString*)name_from:(GameItem)gameitem {
    return [names objectForKey:[NSValue valueWithGameItem:gameitem]];
}

+(NSString*)description_from:(GameItem)gameitem {
    return [descriptions objectForKey:[NSValue valueWithGameItem:gameitem]];
}

@end