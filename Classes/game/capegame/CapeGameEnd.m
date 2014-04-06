#import "CapeGameEnd.h"
#import "Resource.h"
#import "Common.h"
#import "CapeGamePlayer.h"

@implementation CapeGameEnd

+(CapeGameEnd*)cons_pt:(CGPoint)pt {
	return [[CapeGameEnd node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
	[self setPosition:ccp(pt.x,0)];
	[self setAnchorPoint:ccp(0.5,0)];
	[self setTexture:[Resource get_tex:TEX_CHECKERBOARD_TEXTURE]];
	[self setTextureRect:CGRectMake(0, 0, 64, [Common SCREEN].height)];
	active = YES;
	return self;
}

-(void)update:(CapeGameEngineLayer *)g {
	if (!active) return;
	if (g.player.position.x > self.position.x) {
		active = NO;
		[g duration_end];
	}
}

@end
