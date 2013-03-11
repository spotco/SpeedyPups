#import "MainMenuBGLayer.h"
#import "BackgroundObject.h"
#import "Common.h"
#import "CloudGenerator.h"

@implementation MainMenuBGLayer
+(MainMenuBGLayer*)cons {
    MainMenuBGLayer* l = [MainMenuBGLayer node];
    return l;
}

-(id)init {
    self = [super init];
    
    sky = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_SKY] scrollspd_x:0 scrollspd_y:0];
    [sky setTextureRect:CGRectMake(0, 0, [Common SCREEN].width, [Common SCREEN].height)];
    [sky setAnchorPoint:ccp(0,0)];
    [self addChild:sky];
    
    clouds = [CloudGenerator cons];
    [self addChild:clouds];
    
    hills = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_3] scrollspd_x:0.025 scrollspd_y:0.02];
    [self addChild:hills];
    
    
    fg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_BG]];
    [fg setAnchorPoint:ccp(0,0)];
    [self addChild:fg];
    
    return self;
}

-(void)update {
    [clouds update_posx:3 posy:0];
}

-(void)move_fg:(CGPoint)pt { [fg setPosition:pt]; }
-(CGPoint)get_fg_pos{ return fg.position; }

@end

