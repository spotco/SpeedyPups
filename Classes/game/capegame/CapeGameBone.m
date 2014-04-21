#import "CapeGameBone.h"
#import "Resource.h"
#import "Common.h"
#import "CapeGamePlayer.h"
#import "AudioManager.h"
#import "FileCache.h"
#import "DogBone.h"
#import "GameEngineLayer.h" 
#import "ScoreManager.h"

@implementation CapeGameBone

+(CapeGameBone*)cons_pt:(CGPoint)pt {
	return [[CapeGameBone node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
	[self setTexture:[Resource get_tex:TEX_ITEM_SS]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"goldenbone"]];
	[self setPosition:pt];
	active = YES;
	return self;
}

-(void)update:(CapeGameEngineLayer *)g {
	if (!active) return;
	
	if ([Common hitrect_touch:[[g player] get_hitrect] b:[self get_hitrect]]) {
		[self setVisible:NO];
		[g collect_bone:[self convertToWorldSpace:ccp(0,0)]];
		
		[g.get_main_game.score increment_multiplier:0.005];
		[g.get_main_game.score increment_score:10];
		
		[DogBone play_collect_sound:g.get_main_game];
		active = NO;
	}
}

-(HitRect)get_hitrect {
	return [Common hitrect_cons_x1:position_.x-10 y1:position_.y-10 wid:20 hei:20];
}

@end
