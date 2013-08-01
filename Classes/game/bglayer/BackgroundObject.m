
#import "Resource.h"
#import "BackgroundObject.h"
#import "Common.h"

@implementation BackgroundObject
@synthesize scrollspd_x, scrollspd_y;

+(BackgroundObject*) backgroundFromTex:(CCTexture2D *)tex scrollspd_x:(float)spdx scrollspd_y:(float)spdy {
    BackgroundObject *bg = [BackgroundObject spriteWithTexture:tex];
    bg.scrollspd_x = spdx;
    bg.scrollspd_y = spdy;
    bg.anchorPoint = CGPointZero;
    bg.position = CGPointZero;
    ccTexParams par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [bg.texture setTexParameters:&par];
	[bg.texture setAntiAliasTexParameters];
    return bg;
}

-(id)init {
	self = [super init];
	clamp_y_min = -600;
	clamp_y_max = 0;
	return self;
}

-(BackgroundObject*)set_clamp_y_min:(float)min max:(float)max {
	clamp_y_min = min;
	clamp_y_max = max;
	return self;
}

-(void)update_posx:(float)posx posy:(float)posy {
    [self setTextureRect:CGRectMake(
		posx*scrollspd_x,
		0,
		[Common SCREEN].width*2 ,
		[self textureRect].size.height
	)];
	
	self.position = ccp(0,clampf(-posy*scrollspd_y, clamp_y_min, clamp_y_max));
}

@end
