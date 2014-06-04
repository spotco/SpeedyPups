#import "LabEntrance.h"
#import "GameEngineLayer.h"

static const float ENTR_HEI = 3000;

@implementation LabEntranceFG

+(LabEntranceFG*)cons_pt:(CGPoint)pt base:(LabEntrance*)base {
    return [[LabEntranceFG node] cons_pt:pt base:base];
}
-(id)cons_pt:(CGPoint)pt base:(LabEntrance*)tbase {
    [self setPosition:pt];
    base = tbase;
    [[Resource get_tex:TEX_LAB_ENTRANCE_FORE] setHorizClampTexParameters];
    front_body = [Common neu_cons_render_obj:[Resource get_tex:TEX_LAB_ENTRANCE_FORE] npts:4];
    //23
    //01
    
    float tex_wid = front_body.texture.pixelsWide;
    float hei = ENTR_HEI;
    
    front_body.tri_pts[0] = fccp(-tex_wid/2,0);
    front_body.tri_pts[1] = fccp(tex_wid/2,0);
    front_body.tri_pts[2] = fccp(-tex_wid/2,hei);
    front_body.tri_pts[3] = fccp(tex_wid/2,hei);
    
    front_body.tex_pts[2] = fccp(0,0);
    front_body.tex_pts[3] = fccp(1,0);
    front_body.tex_pts[0] = fccp(0,hei/front_body.texture.pixelsHigh);
    front_body.tex_pts[1] = fccp(1,hei/front_body.texture.pixelsHigh);
    return self;
}
-(void)update:(Player *)player g:(GameEngineLayer *)g {
	[super update:player g:g];
	if (![g.game_objects containsObject:base]) {
		[g remove_gameobject:self];
	}
}
-(void)check_should_render:(GameEngineLayer *)g {
    do_render = [base get_do_render];
}
-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_ABOVE_FG_ORD];
}
-(void)draw {
    [super draw];
    [Common draw_renderobj:front_body n_vtx:4];
}
@end

@implementation LabEntrance

+(LabEntrance*)cons_pt:(CGPoint)pt {
    return [[LabEntrance node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
    active = YES;
    [self setPosition:pt];
    [[Resource get_tex:TEX_LAB_ENTRANCE_BACK] setHorizClampTexParameters];
    back_body = [Common neu_cons_render_obj:[Resource get_tex:TEX_LAB_ENTRANCE_BACK] npts:4];
    //23
    //01 then flip horiz
    
    float tex_wid = back_body.texture.pixelsWide;
    float hei = ENTR_HEI;
    
    back_body.tri_pts[0] = fccp(-tex_wid/2,0);
    back_body.tri_pts[1] = fccp(tex_wid/2,0);
    back_body.tri_pts[2] = fccp(-tex_wid/2,hei);
    back_body.tri_pts[3] = fccp(tex_wid/2,hei);
    
    back_body.tex_pts[2] = fccp(0,0);
    back_body.tex_pts[3] = fccp(1,0);
    back_body.tex_pts[0] = fccp(0,hei/back_body.texture.pixelsHigh);
    back_body.tex_pts[1] = fccp(1,hei/back_body.texture.pixelsHigh);

    [[Resource get_tex:TEX_LAB_ENTRANCE_CEIL] setHorizClampTexParameters];
    ceil_edge = [Common neu_cons_render_obj:[Resource get_tex:TEX_LAB_ENTRANCE_CEIL] npts:4];
    
    float ceil_hei = 50;
    float ceil_leftoffset = -40;
    float ceil_wid = ceil_edge.texture.pixelsWide;
    float ceil_edge_hei = ceil_edge.texture.pixelsHigh;
    
    ceil_edge.tri_pts[0] = fccp(ceil_leftoffset,ceil_hei);
    ceil_edge.tri_pts[1] = fccp(ceil_leftoffset+ceil_wid,ceil_hei);
    ceil_edge.tri_pts[2] = fccp(ceil_leftoffset,ceil_hei+ceil_edge_hei);
    ceil_edge.tri_pts[3] = fccp(ceil_leftoffset+ceil_wid,ceil_hei+ceil_edge_hei);
    
    ceil_edge.tex_pts[2] = fccp(0,0);
    ceil_edge.tex_pts[3] = fccp(1,0);
    ceil_edge.tex_pts[0] = fccp(0,1);
    ceil_edge.tex_pts[1] = fccp(1,1);
    
    [[Resource get_tex:TEX_LAB_ENTRANCE_CEIL_REPEAT] setHorizClampTexParameters];
    ceil_body = [Common neu_cons_render_obj:[Resource get_tex:TEX_LAB_ENTRANCE_CEIL_REPEAT] npts:4];
    ceil_body.tri_pts[0] =  fccp(ceil_leftoffset,         ceil_hei+ceil_edge_hei);
    ceil_body.tri_pts[1]  = fccp(ceil_leftoffset+ceil_wid,ceil_hei+ceil_edge_hei);
    ceil_body.tri_pts[2] =  fccp(ceil_leftoffset,         ceil_hei+ceil_edge_hei+ENTR_HEI);
    ceil_body.tri_pts[3]  = fccp(ceil_leftoffset+ceil_wid,ceil_hei+ceil_edge_hei+ENTR_HEI);
    
    ceil_body.tex_pts[2] = fccp(0,0);
    ceil_body.tex_pts[3] = fccp(1,0);
    ceil_body.tex_pts[0] = fccp(0,ceil_body.tri_pts[2].y/ceil_body.texture.pixelsHigh);
    ceil_body.tex_pts[1] = fccp(1,ceil_body.tri_pts[3].y/ceil_body.texture.pixelsHigh);
    
    return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    if (afg_area == NULL) [self add_afg_area:g];
    if (!activated && [Common hitrect_touch:[player get_hit_rect] b:[self get_hit_rect]]) {
        activated = YES;
        [self entrance_event];
    }
}

-(void)entrance_event {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_ENTER_LABAREA]];
}

-(void)reset {
    [super reset];
    activated = NO;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:[self position].x y1:[self position].y wid:50 hei:ENTR_HEI];
}

-(BOOL)get_do_render {
    return do_render;
}

-(void)add_afg_area:(GameEngineLayer*)g {
    afg_area = [LabEntranceFG cons_pt:ccp([self position].x+50,[self position].y-1000) base:self];
    [g add_gameobject:afg_area];
}

-(void)draw {
    [super draw];
    [Common draw_renderobj:back_body n_vtx:4];
    [Common draw_renderobj:ceil_edge n_vtx:4];
    [Common draw_renderobj:ceil_body n_vtx:4];
}

@end
