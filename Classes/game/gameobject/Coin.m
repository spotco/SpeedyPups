#import "Coin.h"
#import "Resource.h" 

@implementation Coin

+(Coin*)cons_pt:(CGPoint)pt {
    return [[Coin node] init_pt:pt];
}

-(id)init_pt:(CGPoint)pt {
    [self setPosition:pt];
    active = YES;
    self.img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_ITEM_SS] rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"star_coin"]];
    [self.img setScale:1.2];
    [self addChild:self.img];
    return self;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-15 y1:position_.y-15 wid:30 hei:30];
}

-(void)hit {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_GET_COIN]];
    active = NO;
}

@end
