#import "UIEnemyAlert.h"
#import "Resource.h"
#import "FileCache.h"

@implementation UIEnemyAlert

+(UIEnemyAlert*)cons {
	return [UIEnemyAlert node];
}

-(id)init {
	self = [super init];
	
	mainbody = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
									  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"enemy_approach_ui"]];
	
	arrow = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
									  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"enemy_approach_ui_arrow"]];
	
	[self addChild:mainbody];
	[mainbody addChild:arrow];
	[self set_dir:[VecLib cons_x:1 y:0 z:0]];
	return self;
}

-(void)set_flash:(BOOL)v {
	[arrow setVisible:v];
}

-(void)set_dir:(Vec3D)dir {
	
	[arrow setRotation:[VecLib get_rotation:dir offset:45]];
	dir = [VecLib scale:dir by:40];
	CGPoint centre = [Common pct_of_obj:mainbody pctx:0.5 pcty:0.5];
	centre.x += dir.x;
	centre.y += dir.y;
	[arrow setPosition:centre];
}

@end
