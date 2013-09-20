#import "ItemGen.h"
#import "UserInventory.h"
#import "AudioManager.h"

@implementation ItemGen

+(ItemGen*)cons_pt:(CGPoint)pt {
	return [[ItemGen node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
	NSValue *pickedvalue = [@[
		[NSValue valueWithGameItem:Item_Clock],
		[NSValue valueWithGameItem:Item_Magnet],
		[NSValue valueWithGameItem:Item_Rocket],
		[NSValue valueWithGameItem:Item_Shield]
	] random];
	[pickedvalue getValue:&item];
	
	TexRect *img = [GameItemCommon object_textrect_from:item];
	[self setTexture:img.tex];
	[self setTextureRect:img.rect];
	[self setPosition:pt];
	
	active = YES;
	
	[self setScale:1.5];
	
	return self;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-15 y1:position_.y-15 wid:30 hei:30];
}

-(void)hit {
	[AudioManager playsfx:SFX_POWERUP];
    [UserInventory set_current_gameitem:item];
	[GEventDispatcher push_event:[GEvent cons_type:GEVentType_PICKUP_ITEM]];
	active = NO;
}

-(void)reset {
    [self setPosition:initial_pos];
    follow = NO;
    vx = 0;
    vy = 0;
    
	active = YES;
}

@end
