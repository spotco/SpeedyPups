#import "Cannon.h"
#import "GameEngineLayer.h"

@implementation CannonMoveTrack
+(CannonMoveTrack*)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return [[CannonMoveTrack node] cons_pt1:pt1 pt2:pt2];
}

-(id)cons_pt1:(CGPoint)_pt1 pt2:(CGPoint)_pt2 {
	pt1 = _pt1;
	pt2 = _pt2;
	[self setPosition:pt1];
	return self;
}

-(CGPoint)get_pt1 {
	return pt1;
}

-(CGPoint)get_pt2 {
	return pt2;
}

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:MIN(pt1.x,pt2.x) y1:MIN(pt1.y,pt2.y) x2:MAX(pt1.x,pt2.x) y2:MAX(pt1.y,pt2.y)];
}
@end

@implementation CannonRotationPoint
+(CannonRotationPoint*)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return [[CannonRotationPoint node] cons_pt1:pt1 pt2:pt2];
}
-(id)cons_pt1:(CGPoint)_pt1 pt2:(CGPoint)_pt2 {
	[super cons_pt1:_pt1 pt2:_pt2];
	return self;
}
@end

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
	
	[self setAnchorPoint:ccp(43.0/self.textureRect.size.width,0.5)];	
	active = YES;
	player_loaded = NO;
	
	has_param_checked = NO;
	has_rotation_all = NO;
	has_rotation_twopt = NO;
	has_move = NO;
	
	return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	if (has_param_checked == NO) {
		[self param_check:g];
		has_param_checked = YES;
	} else {
		[self move];
	}
	[self setRotation:[self ptdir_to_actual_angle:dir]];
	
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
		player_head_out = NO;
		head_out_ct = 10;
		
		player.vx = 0;
		player.vy = 0;
		
		[player remove_temp_params:g];
		[[player get_current_params] add_airjump_count];
		player.dashing = NO;
		
		
	}
	
	if (player_loaded) {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_loaded"]];
		
		if (player_head_out == NO) {
			float pct = 1-head_out_ct/10;
			head_out_ct-=[Common get_dt_Scale];
			CGPoint tarp = [self get_nozzel_position];
			CGPoint neup = ccp(player.position.x+(tarp.x-player.position.x)*pct,player.position.y+(tarp.y-player.position.y)*pct);
			[player setPosition:neup];
		} else {
			[player setPosition:[self get_nozzel_position]];
		}
		player_head_out = [self cannon_show_head:player];
		
		
		[player setRotation:[self ptdir_to_actual_angle:dir]];
		
	} else {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_CANNON_SS idname:@"cannon_normal"]];
	}
}

-(void)param_check:(GameEngineLayer*)g {
	for (GameObject *o in g.game_objects) {
		if ([o class] == [CannonMoveTrack class] && CGPointDist(position_, o.position) < 60) {
			CannonMoveTrack *tar_track = (CannonMoveTrack*)o;
			has_move = YES;
			move_pt1 = [tar_track get_pt1];
			move_pt2 = [tar_track get_pt2];
			[self setPosition:move_pt1];
			break;
		}
	}
	
	CannonRotationPoint *first_r_pt = NULL;
	for (GameObject *o in g.game_objects) {
		if ([o class] == [CannonRotationPoint class] && CGPointDist(position_, o.position) < 60) {
			first_r_pt = (CannonRotationPoint*)o;
			has_rotation_all = YES;
			CGPoint tpt = [first_r_pt get_pt2];
			rotation_angle1 = [self ptdir_to_actual_angle:ccp(tpt.x-position_.x,tpt.y-position_.y)];
			break;
		}
	}
	
	for (GameObject *o in g.game_objects) {
		if ([o class] == [CannonRotationPoint class]  && CGPointDist(position_, o.position) < 60 && o != first_r_pt) {
			has_rotation_all = NO;
			has_rotation_twopt = YES;
			CGPoint tpt = [(CannonRotationPoint*)o get_pt2];
			rotation_angle2 = [self ptdir_to_actual_angle:ccp(tpt.x-position_.x,tpt.y-position_.y)];
			
			break;
		}
	}
}

-(void)move {
	if (has_move) {
		move_theta += 10 * 1/CGPointDist(move_pt1, move_pt2) * [Common get_dt_Scale];
		CGPoint midpt = ccp(move_pt1.x + (move_pt2.x-move_pt1.x)/2,move_pt1.y+(move_pt2.y-move_pt1.y)/2);
		[self setPosition:ccp(
			midpt.x + sinf(move_theta) * (move_pt2.x - move_pt1.x)/2,
			midpt.y + sinf(move_theta) * (move_pt2.y - move_pt1.y)/2
		 )];
	}
	
	if (has_rotation_all) {
		Vec3D cur_dir = [VecLib cons_x:dir.x y:dir.y z:0];
		float spd = ABS(rotation_angle1) > 90 ? -3 : 3;
		cur_dir = [VecLib normalize:[VecLib rotate:cur_dir by_rad:[Common deg_to_rad:spd*[Common get_dt_Scale]]]];
		dir.x = cur_dir.x;
		dir.y = cur_dir.y;
		
	} else if (has_rotation_twopt) {
		Vec3D pt1_vec = [VecLib cons_x:cosf([Common deg_to_rad:rotation_angle1]) y:sinf([Common deg_to_rad:rotation_angle1]) z:0];
		Vec3D pt2_vec = [VecLib cons_x:cosf([Common deg_to_rad:rotation_angle2]) y:sinf([Common deg_to_rad:rotation_angle2]) z:0];
		float angle = [Common rad_to_deg:acosf([VecLib dot:pt1_vec with:pt2_vec])];
		
		rotate_theta += [Common deg_to_rad:(1/(angle))*180];
		
		Vec3D cross = [VecLib cross:pt1_vec with:pt2_vec];
		angle *= [Common sig:[VecLib dot:cross with:[VecLib Z_VEC]]];
		angle *= (sinf(rotate_theta)+1)/2;
		Vec3D target = [VecLib cons_x:cosf([Common deg_to_rad:angle+rotation_angle1]) y:sinf([Common deg_to_rad:angle+rotation_angle1]) z:0];
		dir.x = target.x;
		dir.y = -target.y;
		
	}
}

-(BOOL)cannon_show_head:(Player*)p {
	return player_head_out || CGPointDist([self get_nozzel_position], p.position) < 1;
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

-(void)reset {
	player_loaded = NO;
}

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:position_.x-60 y1:position_.y-60 wid:120 hei:120];
}

-(float)ptdir_to_actual_angle:(CGPoint)_dir {
	Vec3D tangent = [VecLib cross:[VecLib cons_x:_dir.x y:_dir.y z:0] with:[VecLib Z_VEC]];
    float tar_rad = -[VecLib get_angle_in_rad:tangent] - M_PI/2;
	return [Common rad_to_deg:tar_rad];
}

@end
