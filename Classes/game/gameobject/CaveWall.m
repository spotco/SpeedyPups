#import "CaveWall.h"
#import "GameEngineLayer.h"

@implementation CaveWall

+(CaveWall*)cons_x:(float)x y:(float)y width:(float)width height:(float)height {
    CaveWall* n = [CaveWall node];
    [n cons_x:x y:y width:width height:height];
    return n;
}

-(void)cons_x:(float)x y:(float)y width:(float)width height:(float)height {
    [self setPosition:ccp(x,y)];
    wid = width;
    hei = height;
    
    tex = [Common cons_render_obj:[self get_tex] npts:4];
    active = YES;
    /*10
      32*/
    
    tex.tri_pts[3] = ccp(0,0);
    tex.tri_pts[2] = ccp(width,0);
    tex.tri_pts[1] = ccp(0,height);
    tex.tri_pts[0] = ccp(width,height);
    
    for (int i = 0; i < 4; i++) {
        tex.tex_pts[i] = ccp(
			(tex.tri_pts[i].x+position_.x)/tex.texture.pixelsWide,
			-(tex.tri_pts[i].y+position_.y)/tex.texture.pixelsHigh
		);
    }
}

-(CCTexture2D*)get_tex {
    return [Resource get_tex:TEX_GROUND_TEX_1];
}

-(void)draw {
    [super draw];
    if (do_render) {
        [Common draw_renderobj:tex n_vtx:4];
    }
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x y1:position_.y wid:wid hei:hei];
}

-(void)set_active:(BOOL)t_active {
    active = t_active;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_GAMEOBJ_ORD]-1;
}


@end
