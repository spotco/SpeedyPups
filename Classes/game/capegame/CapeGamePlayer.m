#import "CapeGamePlayer.h"
#import "Player.h"
#import "Common.h"

@implementation CapeGamePlayer

+(CapeGamePlayer*)cons {
	return [CapeGamePlayer node];
}

-(id)init {
	self = [super init];
	
	_anim_cape = [Common cons_anim:@[@"cape_0",@"cape_1",@"cape_2",@"cape_3"]
							 speed:0.1
						   tex_key:[Player get_character]];
	_anim_stand = [Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"]
							  speed:0.1
							tex_key:[Player get_character]];
	_anim_rocket = [Common cons_anim:@[@"rocket_0",@"rocket_1",@"rocket_2"]
							   speed:0.1
							 tex_key:[Player get_character]];
	_anim_hit = [Common cons_anim:@[@"hit_2"]
							speed:200
						  tex_key:[Player get_character]];
	
	
	[self do_cape_anim];
	[self setScale:0.6];
	return self;
}

-(void)set_rotation {
	Vec3D vdir_vec = [VecLib cons_x:10 y:self.vy z:0];
	[self setRotation:[VecLib get_rotation:vdir_vec offset:0]+180];
}

-(void)do_cape_anim {
	if (cur_anim != _anim_cape) {
		[self stopAllActions];
		[self runAction:_anim_cape];
		cur_anim = _anim_cape;
	}
}

-(void)do_stand {
	if (cur_anim != _anim_stand) {
		[self stopAllActions];
		[self runAction:_anim_stand];
		cur_anim = _anim_stand;
	}
}

-(void)do_rocket {
	if (cur_anim != _anim_rocket) {
		[self stopAllActions];
		[self runAction:_anim_rocket];
		cur_anim = _anim_rocket;
	}
	
}

-(void)do_hit {
	if (cur_anim != _anim_hit) {
		[self stopAllActions];
		[self runAction:_anim_hit];
		cur_anim = _anim_hit;
	}
}

-(BOOL)is_rocket {
	return cur_anim == _anim_rocket;
}

-(HitRect)get_hitrect {
	return [Common hitrect_cons_x1:position_.x-10 y1:position_.y-10 wid:20 hei:20];
}

@end
