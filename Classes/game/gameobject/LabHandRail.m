#import "LabHandRail.h"
#import "Resource.h"

@implementation LabHandRail

+(LabHandRail*)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return [[LabHandRail node] cons_pt1:pt1 pt2:pt2];
}

-(id)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	CCTexture2D* tex = [Resource get_tex:TEX_LAB_HANDRAIL];
	[self setPosition:pt1];
	dir_vec = [VecLib cons_x:pt2.x-pt1.x y:pt2.y-pt1.y z:0];

	Vec3D normal = [VecLib cross:[VecLib Z_VEC] with:dir_vec];
	normal = [VecLib normalize:normal];
	normal = [VecLib scale:normal by:[tex pixelsHigh]];

	center = [Common cons_render_obj:tex npts:4];

	/*
	      3--2
	      |  | normal/\
	 (0,0)1--0 dir_vec->
	 */
	
	center.tri_pts[0] = ccp(dir_vec.x,dir_vec.y);
	center.tri_pts[1] = ccp(0,0);
	center.tri_pts[2] = ccp(dir_vec.x + normal.x, dir_vec.y + normal.y);
	center.tri_pts[3] = ccp(normal.x,normal.y);
	
	center.tex_pts[3] = ccp([VecLib length:dir_vec]/[tex pixelsWide],0);
	center.tex_pts[2] = ccp(0,0);
	center.tex_pts[1] = ccp([VecLib length:dir_vec]/[tex pixelsWide],0.95);
	center.tex_pts[0] = ccp(0,0.95);
	
	self.active = YES;

	return self;
}

-(void)draw {
	if (!do_render) return;
	[super draw];
	[Common draw_renderobj:center n_vtx:4];
}

-(int)get_render_ord {
	return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD];
}

-(HitRect)get_hit_rect {
	Vec3D normal_vec = [VecLib scale:[VecLib normalize:[VecLib cross:[VecLib Z_VEC] with:dir_vec]] by:[VecLib length:dir_vec]];
	float xmin = MIN(position_.x, MIN(position_.x+normal_vec.x, MIN(position_.x+dir_vec.x, position_.x+normal_vec.x+dir_vec.x)));
	float xmax = MAX(position_.x, MAX(position_.x+normal_vec.x, MAX(position_.x+dir_vec.x, position_.x+normal_vec.x+dir_vec.x)));
	float ymin = MIN(position_.y, MIN(position_.y+normal_vec.y, MIN(position_.y+dir_vec.y, position_.y+normal_vec.y+dir_vec.y)));
	float ymax = MAX(position_.y, MAX(position_.y+normal_vec.y, MAX(position_.y+dir_vec.y, position_.y+normal_vec.y+dir_vec.y)));
	return [Common hitrect_cons_x1:xmin y1:ymin x2:xmax y2:ymax];
}

@end