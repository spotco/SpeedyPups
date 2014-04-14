#import "FileCache.h"
#import "BoneCollectUIAnimation.h"
#import "ObjectPool.h"

@implementation BoneCollectUIAnimation

+(BoneCollectUIAnimation*)cons_start:(CGPoint)start end:(CGPoint)end {
    //BoneCollectUIAnimation *b = [BoneCollectUIAnimation node];
    BoneCollectUIAnimation *b = [ObjectPool depool:[BoneCollectUIAnimation class]];
	
	[b cons_start:start end:end];
    return b;
}

-(void)cons_start:(CGPoint)tstart end:(CGPoint)tend {
    //[self addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_ITEM_SS] rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"goldenbone"]]];
	[self setTexture:[Resource get_tex:TEX_ITEM_SS]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"goldenbone"]];
	[self setOpacity:255];
	[self setScale:1];
	
    start = tstart;
    end = tend;
    [self setPosition:start];
	[self set_ctmax:50];
}

-(void)repool {
	if ([self class] == [BoneCollectUIAnimation class]) [ObjectPool repool:self class:[BoneCollectUIAnimation class]];
}

-(id)set_ctmax:(int)ctm {
	CTMAX = ctm;
	ct = CTMAX;
	return self;
}

-(void)update {
    float pct = (CTMAX - ((float)ct))/CTMAX;
    CGPoint tar = ccp((end.x - start.x)*pct + start.x, (end.y-start.y)*pct + start.y);
    [self setPosition:tar];
    [self setOpacity:((int)((1-pct)*255))];
    
    float tarscale = 2;
    if (ct > 35) {
        tarscale = ((15-(ct-35))/15.0)+1;
    } else {
        tarscale = 2*ct/35.0;
    }
    [self setScale:tarscale];    
    ct-=[Common get_dt_Scale];
}

/*
- (void)setOpacity:(GLubyte)opacity {
	[super setOpacity:opacity];
	for(CCSprite *sprite in [self children]) {
		sprite.opacity = opacity;
	}
}*/

@end
