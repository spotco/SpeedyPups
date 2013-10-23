#import "Cannon.h"

@implementation Cannon
@synthesize dir;

+(Cannon*)cons_pt:(CGPoint)pos dir:(CGPoint)dir {
	return [[Cannon node] cons_pt:pos dir:dir];
}

-(id)cons_pt:(CGPoint)_pos dir:(CGPoint)_dir {
	[self setTexture:[Resource get_tex:TEX_CANNON_SS]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_normal"]];
	
	[self setPosition:_pos];
	self.dir = _dir;
    
    Vec3D tangent = [VecLib cross:[VecLib cons_x:dir.x y:dir.y z:0] with:[VecLib Z_VEC]];
    float tar_rad = -[VecLib get_angle_in_rad:tangent] - M_PI/2;
	[self setRotation:[Common rad_to_deg:tar_rad]];
	
	[self setAnchorPoint:ccp(43.0/self.textureRect.size.width,0.5)];	
	active = YES;
	player_loaded = NO;
	
	return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	deactivate_ct = deactivate_ct > 0 ? deactivate_ct-1 : deactivate_ct;
	if (deactivate_ct > 0) {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_normal"]];
		[self setOpacity:180];
		return;
	} else {
		[self setOpacity:255];
	}
	
	if (!player_loaded && player.current_cannon == NULL && [Common hitrect_touch:[player get_hit_rect] b:[self get_hit_rect]]) {
		player.current_cannon = self;
		player.current_island = NULL;
		player.current_swingvine = NULL;
		player_loaded = YES;
		
		player.vx = 0;
		player.vy = 0;
		
		[player remove_temp_params:g];
		[[player get_current_params] add_airjump_count];
		player.dashing = NO;
		
		
	}
	
	if (player_loaded) {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_loaded"]];
		CGPoint tarp = [self get_nozzel_position];
		CGPoint neup = ccp(player.position.x+(tarp.x-player.position.x)/4,player.position.y+(tarp.y-player.position.y)/4);
		[player setPosition:neup];
		
		Vec3D tangent = [VecLib cross:[VecLib cons_x:dir.x y:dir.y z:0] with:[VecLib Z_VEC]];
		float tar_rad = -[VecLib get_angle_in_rad:tangent] - M_PI/2;
		[player setRotation:[Common rad_to_deg:tar_rad]];
		
	} else {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_normal"]];
	}
}

-(BOOL)cannon_show_head:(Player*)p {
	return CGPointDist([self get_nozzel_position], p.position) < 1;
}

-(void)detach_player {
	player_loaded = NO;
}

-(void)deactivate_for:(int)time {
	deactivate_ct = time;
}

-(CGPoint)get_nozzel_position {
	Vec3D nozzel = [VecLib scale:[VecLib cons_x:dir.x y:dir.y z:0] by:91];
	return CGPointAdd(position_, ccp(nozzel.x,nozzel.y));
}

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:position_.x-60 y1:position_.y-60 wid:120 hei:120];
}

@end
