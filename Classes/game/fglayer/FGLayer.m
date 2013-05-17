#import "FGLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"

#define TMP_FG_PIPE

@implementation FGLayer
@synthesize game_engine_layer;

+(FGLayer*)cons:(GameEngineLayer *)g {
	FGLayer *neu = [FGLayer node];
	neu.game_engine_layer = g;
	[GEventDispatcher add_listener:neu];
	return neu;
}

-(id)init {
	self = [super init];
	
#ifndef TMP_FG_PIPE
	item = [CCSprite spriteWithTexture:[Resource get_tex:TEX_FGSTUFF] rect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"tree0"]];
	[item setScaleX:1.5];
	[item setScaleY:2];
	[item setAnchorPoint:ccp(0.5,0.1)];
#endif
	
#ifdef TMP_FG_PIPE
	item = [CCSprite spriteWithTexture:[Resource get_tex:TEX_FGSTUFF] rect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"pipe0"]];
	[item setAnchorPoint:ccp(0.5,0.1)];
#endif
	
	[self addChild:item];
	
	pt_start = ccp([Common SCREEN].width*1.75,0);
	pt_end = ccp(-[Common SCREEN].width*1,0);
	offy = 0;
	actualpos = pt_end;
	
	return self;
}

-(void)update {
	
    float posx = game_engine_layer.player.position.x;
    float posy = game_engine_layer.player.position.y;
    
    float dx = posx - lastx;
    float dy = posy - lasty;
	
	offy -= dy;
    offy = MAX(-170,offy);
	offy = MIN(0,offy);
	
    lastx = posx;
    lasty = posy;
	
	NSLog(@"offy:%f",offy);
	
	if (ABS(actualpos.x - pt_end.x) > 50) {
		actualpos.x -= dx*1.2;
		[item setPosition:ccp(actualpos.x,actualpos.y+offy)];
		//[item setPosition:ccp(item.position.x-dx*0.8,item.position.y)];
	} else {
		[item setPosition:actualpos];
	}
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_FGITEM_SHOW) {
	
#ifndef TMP_FG_PIPE
		int usepipe = int_random(0, 3);
		if (usepipe == 20) {
			[item setTextureRect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"grass0"]];
			[item setScale:1];
			[item setAnchorPoint:ccp(0.5,0.2)];
		} else {
			[item setTextureRect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"tree0"]];
			[item setScaleX:1.5];
			[item setScaleY:2];
			[item setAnchorPoint:ccp(0.5,0.1)];
		}
#endif
		
#ifdef TMP_FG_PIPE
		int usepipe = int_random(0, 3);
		if (usepipe == 0) {
			[item setTextureRect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"pipe0"]];
		} else if (usepipe == 1) {
			[item setTextureRect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"pipe1"]];
		} else {
			[item setTextureRect:[FileCache get_cgrect_from_plist:TEX_FGSTUFF idname:@"pipe2"]];
		}
#endif
		
		actualpos = pt_start;
		
	} else if (e.type == GEventType_GAME_TICK) {
		[self update];
	}
}

@end
