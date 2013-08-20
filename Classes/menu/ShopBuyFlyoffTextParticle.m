#import "ShopBuyFlyoffTextParticle.h"
#import "Common.h"

@implementation ShopBuyFlyoffTextParticle

+(ShopBuyFlyoffTextParticle*)cons_pt:(CGPoint)pt text:(NSString *)text {
	return [[ShopBuyFlyoffTextParticle node] cons_pt:pt text:text];
}

#define MAX_CT 20.0

-(id)cons_pt:(CGPoint)pt text:(NSString *)text {
	ct = MAX_CT;
	[self addChild:[Common cons_label_pos:CGPointZero
									color:ccc3(200, 30, 30) fontsize:22 str:text]];
	[self setPosition:pt];
	vel = ccp(0,3);
	return self;
}

-(void)update:(GameEngineLayer *)g {
	ct--;
	float pct = 1-ct/MAX_CT;
	[self setOpacity:255-pct*255];
	[self setPosition:CGPointAdd(position_, vel)];
}

-(BOOL)should_remove {
	return ct <= 0;
}

@end
