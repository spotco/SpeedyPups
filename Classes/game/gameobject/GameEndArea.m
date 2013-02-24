#import "GameEndArea.h"

@implementation GameEndArea

+(GameEndArea*)cons_x:(float)x y:(float)y {
    GameEndArea *a = [GameEndArea node];
    a.position = ccp(x,y);
    
    CCTexture2D *tex = [Resource get_tex:TEX_CHECKERFLOOR];
    a.img = [CCSprite spriteWithTexture:tex];
    a.img.anchorPoint = ccp(0,0);
    a.img.position = ccp(0,-32);
    a.img.scale = 1.2;
    [a addChild:a.img];
    
    a.active = YES;
    
    return a;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_ISLAND_ORD];
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x y1:position_.y wid:[img boundingBox].size.width hei:1000];
}

-(void)update:(Player*)player g:(GameEngineLayer *)g {
    [super update:player g:g];
    if (active && [Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        NSLog(@"Reached end");
        active = NO;
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_LEVELEND]];
    }
    
    return;
}

@end
