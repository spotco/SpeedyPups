#import "CapeGamePlayer.h"
#import "Player.h"
#import "Common.h"

@implementation CapeGamePlayer

+(CapeGamePlayer*)cons {
	return [CapeGamePlayer node];
}

-(id)init {
	self = [super init];
	[self do_cape_anim];
	[self setScale:0.6];
	return self;
}

-(void)set_rotation {
	Vec3D vdir_vec = [VecLib cons_x:10 y:self.vy z:0];
	[self setRotation:[VecLib get_rotation:vdir_vec offset:0]+180];
}

-(void)do_cape_anim {
	[self stopAllActions];
	[self runAction:[Common cons_anim:@[@"cape_0",@"cape_1",@"cape_2",@"cape_3"]
								speed:0.1
							  tex_key:[Player get_character]]];
}

-(void)do_stand {
	[self stopAllActions];
	[self runAction:[Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"]
								speed:0.1
							  tex_key:[Player get_character]]];
}

@end
