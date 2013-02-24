#import "BridgeIsland.h"
#import "LineIsland.h"
#import "GameRenderImplementation.h"

@implementation BridgeIsland

+(BridgeIsland*)cons_pt1:(CGPoint)start pt2:(CGPoint)end height:(float)height ndir:(float)ndir can_land:(BOOL)can_land {
	BridgeIsland *new_island = [BridgeIsland node];
    new_island.fill_hei = height;
    new_island.ndir = ndir;
	[new_island set_pt1:start pt2:end];
	[new_island calc_init];
	new_island.anchorPoint = ccp(0,0);
	new_island.position = ccp(new_island.startX,new_island.startY);
    new_island.can_land = can_land;
	[new_island cons_tex];
	return new_island;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_BTWN_PLAYER_ISLAND];
}

-(void)calc_init {
    self.self.t_min = 0;
    self.t_max = sqrtf(powf(self.endX - self.startX, 2) + powf(self.endY - self.startY, 2));
}

-(void)cons_tex {
    float BEDGE_WID = 13;
    float BEDGE_HEI = 32;
    
    float BCENTER_WID = 32;
    float BCENTER_HEI = 39*2;
    
    CGPoint p2off = ccp(self.endX-self.startX,self.endY-self.startY);
    Vec3D *linedir = [Vec3D cons_x:p2off.x y:p2off.y z:0];
    [linedir normalize];
    
    Vec3D *linenormal = [linedir crossWith:[Vec3D Z_VEC]];
    [linenormal normalize];
    
    /*
     23 --23---23
     
     01   01   01
     */
    [linedir scale:-BEDGE_WID];
    [linenormal scale:BEDGE_HEI];
    left = [Common cons_render_obj:[Resource get_tex:TEX_BRIDGE_EDGE] npts:4];
    left.tri_pts[0] = ccp(linedir.x,linenormal.y);
    left.tri_pts[1] = ccp(0,linenormal.y);
    left.tri_pts[2] = ccp(linedir.x,0);
    left.tri_pts[3] = ccp(0,0);
    
    left.tex_pts[0] = ccp(0,0);
    left.tex_pts[1] = ccp(1,0);
    left.tex_pts[2] = ccp(0,1);
    left.tex_pts[3] = ccp(1,1);
    
    [linedir normalize];
    [linedir scale:-BEDGE_WID];
    right = [Common cons_render_obj:[Resource get_tex:TEX_BRIDGE_EDGE] npts:4];
    right.tri_pts[1] = ccp(p2off.x+linedir.x,p2off.y+linenormal.y);
    right.tri_pts[0] = ccp(p2off.x,p2off.y+linenormal.y);
    right.tri_pts[3] = ccp(p2off.x+linedir.x,p2off.y);
    right.tri_pts[2] = ccp(p2off.x,p2off.y);
    
    right.tex_pts[1] = ccp(0,0);
    right.tex_pts[0] = ccp(1,0);
    right.tex_pts[3] = ccp(0,1);
    right.tex_pts[2] = ccp(1,1);
    
    [linedir normalize];
    [linedir scale:2];
    for(int i = 0; i < 4; i++) {
        right.tri_pts[i].x -= linedir.x;
        right.tri_pts[i].y -= linedir.y;
        left.tri_pts[i].x += linedir.x;
        left.tri_pts[i].y += linedir.y;
    }
    
    
    linedir = [Vec3D cons_x:p2off.x y:p2off.y z:0];
    linenormal = [linedir crossWith:[Vec3D Z_VEC]];
    [linenormal normalize];
    [linenormal scale:BCENTER_HEI];
    
    center = [Common cons_render_obj:[Resource get_tex:TEX_BRIDGE_SECTION] npts:4];
    center.tri_pts[0] = ccp(linenormal.x,linenormal.y);
    center.tri_pts[1] = ccp(linedir.x+linenormal.x,linedir.y+linenormal.y);
    center.tri_pts[2] = ccp(0,0);
    center.tri_pts[3] = ccp(linedir.x,linedir.y);
    
    [linenormal normalize];
    [linenormal scale:-10];
    for(int i = 0; i < 4; i++) {
        center.tri_pts[i].x += linenormal.x;
        center.tri_pts[i].y += linenormal.y;
    }
    
    float reps = [linedir length] / BCENTER_WID;
    reps = floorf(reps);
    
    center.tex_pts[2] = ccp(0,0);
    center.tex_pts[3] = ccp(reps,0);
    center.tex_pts[0] = ccp(0,1);
    center.tex_pts[1] = ccp(reps,1);
    
}

-(void)link_finish {
    if (self.next != NULL && [self.next isKindOfClass:[LineIsland class]]) {
        ((LineIsland*)self.next).force_draw_leftline = YES;
    }
}

-(void)draw {
    [super draw];
    [Common draw_renderobj:left n_vtx:4];
    [Common draw_renderobj:right n_vtx:4];
    [Common draw_renderobj:center n_vtx:4];
//    glColor4f(1.0, 0, 0, 1.0);
//    ccDrawLine(ccp(0,0), ccp(self.endX-self.startX,endY-startY));
}


@end
