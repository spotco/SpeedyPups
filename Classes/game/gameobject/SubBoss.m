#import "SubBoss.h"
#import "GameEngineLayer.h"
#import "BGLayer.h"
#import "Lab2BGLayerSet.h"

@interface FGWater : GameObject
+(FGWater*)cons;
@property (readwrite,assign) float offset;
@end

@implementation FGWater
@synthesize offset;
+(FGWater*)cons {
	return [[FGWater spriteWithTexture:[Resource get_tex:TEX_LAB2_WATER_FG]] cons_it];
}
-(id)cons_it {
	[self setAnchorPoint:ccp(0.5,1)];
	active = YES;
	return self;
}
-(void)update:(CGPoint)player_pos {
	player_pos.x *= 1.1;
	float xpos = ((int)(player_pos.x))%self.texture.pixelsWide + ((player_pos.x) - ((int)(player_pos.x)));
	[self setTextureRect:CGRectMake(
		xpos,
		0,
		[Common SCREEN].width*4,
		[self textureRect].size.height
	)];
}
-(void)check_should_render:(GameEngineLayer *)g {
	do_render = YES;
}
-(int)get_render_ord {
	return [GameRenderImplementation GET_RENDER_ABOVE_FG_ORD];
}
@end

@implementation SubBoss

static CCAction* _anim_body_normal = NULL;
static CCAction* _anim_body_angry;
static CCAction* _anim_body_bite;
static CCAction* _anim_hatch_closed_to_cannon;
static CCAction* _anim_hatch_cannon_to_closed;
static CCAction* _anim_hatch_closed;
static CCAction* _anim_wake;

+(SubBoss*)cons_with:(GameEngineLayer *)g {
	return [[SubBoss node] cons:g];
}

-(id)cons:(GameEngineLayer*)g {
	body = [CCSprite node];
	hatch = [CCSprite node];
	wake = [CCSprite node];
	[self addChild:body];
	[hatch setAnchorPoint:ccp(0.5,0)];
	[body addChild:hatch];
	[wake setAnchorPoint:ccp(1,0.5)];
	[body addChild:wake];
	[SubBoss cons_anims];
	
	[hatch setPosition:ccp(215,195)];
	[wake setPosition:ccp(100,110)];
	
	[body runAction:_anim_body_normal];
	[hatch runAction:_anim_hatch_closed];
	[wake runAction:_anim_wake];
	
	active = YES;
	do_render = YES;
	current_mode = SubMode_Intro;
	
	bgobj = [[g get_bg_layer] get_subboss_bgobject];
	[bgobj setPosition:ccp(-100,bgobj.position.y)];
	[bgobj setScale:1];
	
	[bgobj setVisible:NO];
	[body setVisible:NO];
	
	fgwater = [FGWater cons];
	fgwater.offset = 1000;
	[g add_gameobject:fgwater];
	
	return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	[self set_bounds_and_ground:g];
	
	fgwater.offset += (150-fgwater.offset)/10.0;
	[fgwater setPosition:ccp(player.position.x,groundlevel-fgwater.offset)];
	[fgwater update:player.position];
	
	if (current_mode == SubMode_ToRemove) {
		[g remove_gameobject:self];
		[g remove_gameobject:fgwater];
		
	} else if (current_mode == SubMode_Intro) {
		[bgobj setVisible:YES];
		[body setVisible:NO];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setPosition:ccp(bgobj.position.x+2*[Common get_dt_Scale],bgobj.position.y)];
		if (bgobj.position.x > [Common SCREEN].width+300) {
			current_mode = SubMode_Attack1;
		}
		
	} else if (current_mode == SubMode_Attack1) {
		NSLog(@"attack1");
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setVisible:NO];
		[body setVisible:NO];
	}
}

-(void)set_bounds_and_ground:(GameEngineLayer*)g {
    float yl_min = g.player.position.y;
	Island *lowest = NULL;
	for (Island *i in g.islands) {
		if (i.endX > g.player.position.x && i.startX < g.player.position.x) {
			if (lowest == NULL || lowest.startY > i.startY) {
				lowest = i;
			}
		}
	}
	if (lowest != NULL) {
		yl_min = lowest.startY;
	}
    
	[g frame_set_follow_clamp_y_min:yl_min-500 max:yl_min+300];
	groundlevel = yl_min;
}

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:position_.x y1:position_.y wid:1 hei:1];
}

-(void)check_should_render:(GameEngineLayer *)g {
	do_render = YES;
}

-(void)reset {
	current_mode = SubMode_ToRemove;
}

+(void)cons_anims {
	if (_anim_body_normal != NULL) return;
	_anim_body_normal = [Common cons_anim:@[@"body_normal"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_body_angry = [Common cons_anim:@[@"body_bite0"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_body_bite = [Common cons_anim:@[@"body_bite0",
										  @"body_bite1",
										  @"body_bite2",
										  @"body_bite3"]
								  speed:0.1
								tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed = [Common cons_anim:@[@"hatch_0"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed_to_cannon = [Common cons_anim:@[@"hatch_0",
													   @"hatch_1",
													   @"hatch_cannon_0",
													   @"hatch_cannon_1",
													   @"hatch_cannon_2"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed_to_cannon = [Common cons_anim:@[@"hatch_cannon_2",
													   @"hatch_cannon_1",
													   @"hatch_cannon_0",
													   @"hatch_1",
													   @"hatch_0"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_wake = [Common cons_anim:@[@"wake_0",@"wake_1",@"wake_2"] speed:0.15 tex_key:TEX_ENEMY_SUBBOSS];
	
}

@end
