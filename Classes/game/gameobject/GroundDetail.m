#import "GroundDetail.h"
#import "GameEngineLayer.h"

@implementation GroundDetail
@synthesize imgtype;

static NSMutableArray* IDTOKEY;
+(NSString*)id_to_key:(int)gid {
    if (IDTOKEY==NULL) IDTOKEY = [NSMutableArray arrayWithObjects:
      @"",
      @"fence",
      @"sign_go",
      @"sign_dog",
      @"sign_dog2",
      @"sign_noswim",
      @"tree1",
      @"lab_light",
      @"lab_pipe",
      @"lab_pipe2",
      @"sign_vines",
      @"sign_warning",
      @"sign_rocks",
      @"sign_water",
      @"sign_spikes",
    nil];
    return [IDTOKEY objectAtIndex:gid];
}

+(GroundDetail*)cons_x:(float)posx y:(float)posy type:(int)type islands:(NSMutableArray *)islands{
    GroundDetail *d = [GroundDetail node];
    d.position = ccp(posx,posy);
    
    CGRect texrect = [FileCache get_cgrect_from_plist:TEX_GROUND_DETAILS idname:[self id_to_key:type]];
    d.img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_GROUND_DETAILS] rect:texrect];
    [d.img setPosition:ccp(0,texrect.size.height/2)];
    
    [d addChild:d.img];
    [d attach_toisland:islands];
    return d;
}

-(int)get_render_ord {
    if (imgtype == 9) {
        return [GameRenderImplementation GET_RENDER_BTWN_PLAYER_ISLAND];
    } else {
        return [super get_render_ord];
    }
}

-(void)check_should_render:(GameEngineLayer *)g {
    if ([Common hitrect_touch:[g get_viewbox] b:[self get_hit_rect]]) {
        do_render = YES;
    } else {
        do_render = NO;
    }
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x y1:position_.y wid:1 hei:1];
}

-(void)attach_toisland:(NSMutableArray*)islands {
    Island* i = [self get_connecting_island:islands];
    if (i != NULL) {
        Vec3D tangent_vec = [i get_tangent_vec];
        tangent_vec=[VecLib scale:tangent_vec by:[i ndir]];
        float tar_rad = -[VecLib get_angle_in_rad:tangent_vec];
        float tar_deg = [Common rad_to_deg:tar_rad];
        img.rotation = tar_deg;
        
        tangent_vec = [VecLib normalize:tangent_vec];
        Vec3D normal_vec = [VecLib cross:[VecLib Z_VEC] with:tangent_vec];
        
        if (imgtype == 9) {
            normal_vec = [VecLib scale:normal_vec by:-8];
            [self setPosition:[VecLib transform_pt:position_ by:normal_vec]];
        }
    }
}


@end
