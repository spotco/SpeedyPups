#import "BGSubBossRocketParticle.h"
#import "FileCache.h"

@implementation BGSubBossRocketParticle

+(BGSubBossRocketParticle*)cons_pt:(CGPoint)pt {
	return [[BGSubBossRocketParticle spriteWithTexture:[Resource get_tex:TEX_ENEMY_ROCKET]] cons_pt:pt];
}

-(CCAction*)cons_anim:(NSArray*)a speed:(float)speed {
	CCTexture2D *texture = [Resource get_tex:TEX_CANNONTRAIL];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:TEX_CANNONTRAIL idname:k]]];
    return  [Common make_anim_frames:animFrames speed:0.1];
}

-(id)cons_pt:(CGPoint)pt {
	[self setRotation:90];
	[self setPosition:pt];
	[self setScale:0.25];
	
	CCSprite *trail = [CCSprite node];
    [trail setScale:0.75];
    [trail setPosition:ccp(115,29)];
    [trail runAction:[self cons_anim:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil] speed:0.1]];
    [self addChild:trail z:1];
	
	return self;
}

-(void)update:(GameEngineLayer *)g {
	[self setPosition:CGPointAdd([self position], ccp(0,4*[Common get_dt_Scale]))];
}

-(BOOL)should_remove {
	return [self position].y > [Common SCREEN].height + 100;
}

@end
