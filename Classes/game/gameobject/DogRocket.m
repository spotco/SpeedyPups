#import "DogRocket.h"

@implementation DogRocket
@synthesize img;

+(DogRocket*)cons_x:(float)x y:(float)y {
    DogRocket *new_rocket = [DogRocket node];
    new_rocket.active = YES;
    new_rocket.position = ccp(x,y);
    
    new_rocket.img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_ITEM_SS] rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"dogrocket"]];
    [new_rocket addChild:new_rocket.img];
    
    return new_rocket;
}

//TODO -- launch in direction of slope
-(void)update:(Player*)player g:(GameEngineLayer *)g{
    [super update:player g:g];
    if (!active) {
        return;
    }
    
    float rot = [self rotation];
    if (anim_toggle) {
        rot+=0.5;
        if (rot > 10) {
            anim_toggle = !anim_toggle;
        }
    } else {
        rot-=0.5;
        if (rot < -10) {
            anim_toggle = !anim_toggle;
        }
    }
    [self setRotation:rot];
    
    
    if ([Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        PlayerEffectParams *e = [DogRocketEffect cons_from:[player get_default_params] time:300];
        player.vx += ABS(player.vy);
        player.vy = 0;
        [player add_effect:e];
        [self set_active:NO];
    }
    
    return;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:[self position].x-10 y1:[self position].y-10 wid:20 hei:20];
}

-(void)set_active:(BOOL)t_active {
    if (t_active) {
        visible_ = YES;
    } else {
        visible_ = NO;
    }
    active = t_active;
}

@end
