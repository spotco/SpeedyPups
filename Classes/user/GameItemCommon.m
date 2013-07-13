#import "GameItemCommon.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineLayer.h"
#import "DogRocketEffect.h"
#import "UserInventory.h"

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
        [NSValue valueWithGameItem:Item_Heart]: @"Heart",
        [NSValue valueWithGameItem:Item_Magnet]: @"Magnet",
        [NSValue valueWithGameItem:Item_Rocket]: @"Rocket",
        [NSValue valueWithGameItem:Item_Shield]: @"Shield",
		[NSValue valueWithGameItem:Item_Clock]: @"Clock"
    };
    
    descriptions = @{
        [NSValue valueWithGameItem:Item_Heart]: @"Carry it to take an extra hit from any obstable.",
        [NSValue valueWithGameItem:Item_Magnet]: @"Bones and other goodies will come your way!",
        [NSValue valueWithGameItem:Item_Rocket]: @"Zoom past your troubles!",
        [NSValue valueWithGameItem:Item_Shield]: @"Brief invincibility. Run past anything!",
		[NSValue valueWithGameItem:Item_Clock]: @"Slow down time"
    };
}

+(TexRect*)texrect_from:(GameItem)gameitem {
    CCTexture2D* tex = [Resource get_tex:TEX_ITEM_SS];
    if (gameitem == Item_Magnet) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_magnet"]];
    if (gameitem == Item_Rocket) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_rocket"]];
    if (gameitem == Item_Shield) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_shield"]];
    if (gameitem == Item_Heart) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_heart"]];
	if (gameitem == Item_Clock) return [TexRect cons_tex:tex rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_clock"]];
    if (gameitem == Item_NOITEM) return [TexRect cons_tex:tex rect:CGRectZero];
    [NSException raise:@"unknown gameitem" format:@"%d",gameitem];
    return NULL;
}


+(NSString*)name_from:(GameItem)gameitem {
	if ([UserInventory get_upgrade_level:gameitem] == 0)
		return [NSString stringWithFormat:@"%@ (Locked)",
				[names objectForKey:[NSValue valueWithGameItem:gameitem]]
		];
	
    return [NSString stringWithFormat:@"%@ (lvl %d)",
            [names objectForKey:[NSValue valueWithGameItem:gameitem]],
            [UserInventory get_upgrade_level:gameitem]
    ];
}

+(NSString*)description_from:(GameItem)gameitem {
    return [descriptions objectForKey:[NSValue valueWithGameItem:gameitem]];
}

+(void)use_item:(GameItem)it on:(GameEngineLayer*)g {
    if (it == Item_Rocket) {
        [g.player add_effect:[DogRocketEffect cons_from:[g.player get_current_params] time:[self get_uselength_for:it]]];
        
    } else if (it == Item_Magnet) {
        [g.player set_magnet_rad:250 ct:[self get_uselength_for:Item_Magnet]];
        
    } else if (it == Item_Shield) {
        [g.player set_armored:[self get_uselength_for:Item_Shield]];
        
    } else if (it == Item_Heart) {
        [g.player set_heart:[self get_uselength_for:Item_Heart]];
        
    } else if (it == Item_Clock) {
		[g.player set_clockeffect:[self get_uselength_for:Item_Clock]];
		
	}
}

+(int)get_uselength_for:(GameItem)gi {
	return 100;
}

+(int)get_cooldown_for:(GameItem)gi {
	return 100;
}

@end