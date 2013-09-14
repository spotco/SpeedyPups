#import "CapeGameEngineLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "BackgroundObject.h"
#import "CapeGamePlayer.h"

@implementation CapeGameEngineLayer

+(CCScene*)scene_with_level:(NSString *)file {
	CCScene *scene = [CCScene node];
	[scene addChild:[[CapeGameEngineLayer node] cons_with_level:file]];
	return scene;
}

-(id)cons_with_level:(NSString*)file {
	[self addChild:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_SKY] scrollspd_x:0 scrollspd_y:0]];
	
	player = [CapeGamePlayer cons];
	[player setPosition:[Common screen_pctwid:0.2 pcthei:0.5]];
	[self addChild:player];
	
	
	top_scroll = [CCSprite spriteWithTexture:[Resource get_tex:TEX_CLOUDGAME_CLOUDFLOOR]];
	[top_scroll setScaleY:-1];
	[top_scroll setPosition:[Common screen_pctwid:0 pcthei:1]];
	bottom_scroll = [CCSprite spriteWithTexture:[Resource get_tex:TEX_CLOUDGAME_CLOUDFLOOR]];
	[top_scroll setAnchorPoint:ccp(0,0)];
	[bottom_scroll setAnchorPoint:ccp(0,0)];
	[self addChild:top_scroll];
	[self addChild:bottom_scroll];
	
	
	self.isTouchEnabled = YES;
	[self schedule:@selector(update:)];
	
	touch_down = NO;
	
	return self;
}

-(void)update:(ccTime)dt {
	CGRect scroll_rect = top_scroll.textureRect;
	scroll_rect.origin.x += 4;
	scroll_rect.origin.x = ((int)(scroll_rect.origin.x))%top_scroll.texture.pixelsWide + ((scroll_rect.origin.x) - ((int)(scroll_rect.origin.x)));
	[top_scroll setTextureRect:scroll_rect];
	[bottom_scroll setTextureRect:scroll_rect];
	
	if (touch_down) {
		player.vy = MIN(player.vy + 2, 7);
	} else {
		player.vy = MAX(player.vy - 0.5,-7);
	}
	CGPoint neupos = CGPointAdd(player.position, ccp(0,player.vy));
	neupos.y = clampf(neupos.y, [Common SCREEN].height*0.1, [Common SCREEN].height*0.9);
	player.position = neupos;
	
	Vec3D vdir_vec = [VecLib cons_x:10 y:player.vy z:0];
	[player setRotation:[VecLib get_rotation:vdir_vec offset:0]+180];
}

-(void) ccTouchesBegan:(NSSet*)pTouches withEvent:(UIEvent*)pEvent {
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
	touch_down = YES;
}
-(void) ccTouchesMoved:(NSSet *)pTouches withEvent:(UIEvent *)event {    
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
}
-(void) ccTouchesEnded:(NSSet*)pTouches withEvent:(UIEvent*)event {
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
	touch_down = NO;
}

@end
