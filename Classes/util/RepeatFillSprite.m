#import "RepeatFillSprite.h"

@implementation RepeatFillSprite

+(RepeatFillSprite*)cons_tex:(CCTexture2D *)tex rect:(CGRect)rect rep:(int)rep {
	return [[RepeatFillSprite node] cons_tex:tex rect:rect rep:rep];
}

-(id)cons_tex:(CCTexture2D *)tex rect:(CGRect)rect rep:(int)rep {
	for (int i = 0; i < rep; i++) {
		CCSprite *subspr = [CCSprite spriteWithTexture:tex rect:rect];
		[subspr setPosition:ccp(i*rect.size.width-i,0)];
		[self addChild:subspr];
	}
	return self;
}

@end
