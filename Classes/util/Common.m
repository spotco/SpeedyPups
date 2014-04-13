#import "Common.h"
#import "Island.h"
#import "GameRenderImplementation.h"
#import "GameMain.h"

@implementation CCSprite_VerboseDealloc
-(void)dealloc {
	NSLog(@"dealloq!!");
}
@end

@implementation CallBack
@synthesize selector;
@synthesize target;
@end

@implementation GLRenderObject
    @synthesize isalloc,pts;
    @synthesize texture;
    -(fCGPoint*)tex_pts {return tex_pts;}
    -(fCGPoint*)tri_pts {return tri_pts;}
@end

fCGPoint fCGPointMake(float x, float y){
	fCGPoint rtv;
	rtv.x = x;
	rtv.y = y;
	return rtv;
}

@implementation TexRect
@synthesize tex;
@synthesize rect;
+(TexRect*)cons_tex:(CCTexture2D *)tex rect:(CGRect)rect {
    TexRect *r = [[TexRect alloc] init]; [r setTex:tex]; [r setRect:rect]; return r;
}
@end

@implementation Common

NSString* strf (char* format, ... ) {
    char outp[255];
    va_list a_list;
    va_start( a_list, format );
    vsprintf(outp, format, a_list);
    va_end(a_list);
    return [NSString stringWithUTF8String:outp];
}

int SIG(float n) {
    if (n > 0) {
        return 1;
    } else if (n < 0) {
        return -1;
    } else {
        return 0;
    }
}

inline CGPoint CGPointAdd(CGPoint a,CGPoint b) {
    return ccp(a.x+b.x,a.y+b.y);
}

int pb(int base,float pctm) {return base+(255-base)*pctm;}
ccColor3B PCT_CCC3(int _R,int _G,int _B,float _PCTM) { return ccc3(pb(_R,_PCTM),pb(_G,_PCTM),pb(_B,_PCTM)); }

inline float CGPointDist(CGPoint a,CGPoint b) {
    return sqrtf(powf(a.x-b.x, 2)+powf(a.y-b.y, 2));
}

static BOOL has_set_sdt = NO;
static ccTime sdt = 1;
static ccTime last_sdt = 1;
+(void)set_dt:(ccTime)dt {
	if (!has_set_sdt) {
		has_set_sdt = YES;
		sdt = dt;
		last_sdt = dt;
		return;
	}

	last_sdt = sdt;
	sdt = dt;
	if (ABS(sdt-last_sdt) > 0.01) {
		sdt = last_sdt + 0.01 * SIG(sdt-last_sdt);
	}
}

+(void)unset_dt {
	has_set_sdt = NO;
}

+(float)get_dt_Scale {
	if ([GameMain GET_DO_CONSTANT_DT] || [CCDirectorDisplayLink is_framemodct_modified]) return 1;
	return sdt/(1/60.0f);
}

+(CGSize)SCREEN {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
}

+(CGPoint)screen_pctwid:(float)pctwid pcthei:(float)pcthei {
    return ccp([Common SCREEN].width*pctwid,[Common SCREEN].height*pcthei);
}

+(void)run_callback:(CallBack*)c {
    if (c.target != NULL) {
        [c.target performSelector:c.selector];
    } else {
        NSLog(@"callback target is null");
    }
}

+(CallBack*)cons_callback:(NSObject*)tar sel:(SEL)sel {
    CallBack* cb = [[CallBack alloc] init];
    cb.target = tar;
	cb.selector = sel;
    return cb;
}

+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 {
    struct HitRect n;
    n.x1 = x1;
    n.y1 = y1;
    n.x2 = x2;
    n.y2 = y2;
    return n;
}

+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 wid:(float)wid hei:(float)hei {
    return [Common hitrect_cons_x1:x1 y1:y1 x2:x1+wid y2:y1+hei];
}

+(CGRect)hitrect_to_cgrect:(HitRect)rect {
    return CGRectMake(rect.x1, rect.y1, rect.x2-rect.x1, rect.y2-rect.y1);
}

+(CGPoint*)hitrect_get_pts:(HitRect)rect {
    CGPoint *pts = (CGPoint*) malloc(sizeof(CGPoint)*4);
//    pts[0] = ccp(rect.x1,rect.y1);
//    pts[1] = ccp(rect.x1+(rect.x2-rect.x1),rect.y1);
//    pts[2] = ccp(rect.x2,rect.y2);
//    pts[3] = ccp(rect.x1,rect.y1+(rect.y2-rect.y1));
    
    pts[0] = ccp(rect.x1,rect.y1);
    pts[1] = ccp(rect.x2,rect.y1);
    pts[2] = ccp(rect.x2,rect.y2);
    pts[3] = ccp(rect.x1,rect.y2);

    return pts;
    
}

+(BOOL)hitrect_touch:(HitRect)r1 b:(HitRect)r2 {
    return !(r1.x1 > r2.x2 ||
             r2.x1 > r1.x2 ||
             r1.y1 > r2.y2 ||
             r2.y1 > r1.y2);
}

+(CGPoint)line_seg_intersection_a1:(CGPoint)a1 a2:(CGPoint)a2 b1:(CGPoint)b1 b2:(CGPoint)b2 {//2 line segment intersection (seg a1,a2) (seg b1,b2)
    CGPoint null_point = CGPointMake([Island NO_VALUE], [Island NO_VALUE]);
    double Ax = a1.x; double Ay = a1.y;
	double Bx = a2.x; double By = a2.y;
	double Cx = b1.x; double Cy = b1.y;
	double Dx = b2.x; double Dy = b2.y;
	double X; double Y;
	double  distAB, theCos, theSin, newX, ABpos ;
	
	if ((Ax==Bx && Ay==By) || (Cx==Dx && Cy==Dy)) return null_point; //  Fail if either line segment is zero-length.
    
	Bx-=Ax; By-=Ay;//Translate the system so that point A is on the origin.
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;
	
	distAB=sqrt(Bx*Bx+By*By);//Discover the length of segment A-B.
	
	theCos=Bx/distAB;//Rotate the system so that point B is on the positive X axis.
	theSin=By/distAB;
    
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;
	
	if ((Cy<0. && Dy<0.) || (Cy>=0. && Dy>=0.)) return null_point;//C-D must be origin crossing line
	
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);//Discover the position of the intersection point along line A-B.
	
    
	if (ABpos<0. || /*ABpos>distAB*/ fm_a_gt_b(ABpos, distAB, 0.001)) {
        return null_point;//  Fail if segment C-D crosses line A-B outside of segment A-B.
	}
        
	X=Ax+ABpos*theCos;//Apply the discovered position to line A-B in the original coordinate system.
	Y=Ay+ABpos*theSin;
	
	return ccp(X,Y);
}
/*
 line_seg player_mov = [Common cons_line_seg_a:ccp(0,0) b:ccp(0,1)];
 line_seg a1 = [Common cons_line_seg_a:ccp(-1,0) b:ccp(0,0)];
 line_seg a2 = [Common cons_line_seg_a:ccp(1,0) b:ccp(0,0)];
 CGPoint i1 = [Common line_seg_intersection_a:player_mov b:a1];
 CGPoint i2 = [Common line_seg_intersection_a:player_mov b:a2];
 NSLog(@"a1:(%f,%f) a2:(%f,%f)",i1.x,i1.y,i2.x,i2.y);
 */

bool fm_a_gt_b(double a,double b,double delta) {
    return a-b > delta;
}

+(CGPoint)line_seg_intersection_a:(line_seg)a b:(line_seg)b {
    return [Common line_seg_intersection_a1:a.a a2:a.b b1:b.a b2:b.b];
}

+(line_seg)cons_line_seg_a:(CGPoint)a b:(CGPoint)b {
    struct line_seg new;
    new.a = a;
    new.b = b;
    return new;
}

+(BOOL)point_fuzzy_on_line_seg:(line_seg)seg pt:(CGPoint)pt {
    Vec3D b_m_a = [VecLib cons_x:seg.b.x-seg.a.x y:seg.b.y-seg.a.y z:0];
    Vec3D c_m_a = [VecLib cons_x:pt.x-seg.a.x y:pt.y-seg.a.y z:0];
    Vec3D ab_c_ac = [VecLib cross:b_m_a with:c_m_a];
    
    float val = [VecLib length:ab_c_ac] / [VecLib length:b_m_a];
    if (val <= 0.1) {
        return YES;
    } else {
        return NO;
    }
}

+(void)print_hitrect:(HitRect)l msg:(NSString*)msg {
    NSLog(@"%@ line segment (%f,%f) to (%f,%f)",msg,l.x1,l.y1,l.x2,l.y2);
}
+(NSString*)hitrect_to_string:(HitRect)r {
    return NSStringFromCGRect([Common hitrect_to_cgrect:r]);
}

+(void)print_line_seg:(line_seg)l msg:(NSString*)msg {
    NSLog(@"%@ line segment (%f,%f) to (%f,%f)",msg,l.a.x,l.a.y,l.b.x,l.b.y);
}

+(BOOL)pt_fuzzy_eq:(CGPoint)a b:(CGPoint)b {
    return [Common fuzzyeq_a:a.x b:b.x delta:0.1] && [Common fuzzyeq_a:a.y b:b.y delta:0.1]; //return ABS(a.x-b.x) <= 0.1 && ABS(a.y-b.y) <= 0.1;
}

+(BOOL)fuzzyeq_a:(float)a b:(float)b delta:(float)delta {
    return ABS(a-b) <= delta;
}

+(float)deg_to_rad:(float)degrees {
    return degrees * M_PI / 180.0;
}

+(float)rad_to_deg:(float)rad {
    return rad * 180.0 / M_PI;
}

+(float)shortest_dist_from_cur:(float)a1 to:(float)a2 {
    a1 = [Common deg_to_rad:a1];
    a2 = [Common deg_to_rad:a2];
    float res = atan2f(cosf(a1)*sinf(a2)-sinf(a1)*cosf(a2),
                       sinf(a1)*sinf(a2)+cosf(a1)*cosf(a2));
    
    res = [Common rad_to_deg:res];
    return res;
}

+(float)sig:(float)n {
    if (n > 0) {
        return 1;
    } else if (n < 0) {
        return -1;
    } else {
        return 0;
    }
}

+(GLRenderObject*)cons_render_obj:(CCTexture2D*)tex npts:(int)npts {
    GLRenderObject *n = [[GLRenderObject alloc] init];
    n.texture = tex;
    n.isalloc = 1;
    n.pts = npts;
    return n;
}

+(void)draw_renderobj:(GLRenderObject*)obj n_vtx:(int)n_vtx {    
    glBindTexture(GL_TEXTURE_2D, obj.texture.name);
	glVertexPointer(2, GL_FLOAT, 0, obj.tri_pts); 
	glTexCoordPointer(2, GL_FLOAT, 0, obj.tex_pts);
    
    
    if (n_vtx == 4) {
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    } else {
        glDrawArrays(GL_TRIANGLES, 0, 3);
    }
}

+(void)tex_map_to_tri_loc:(GLRenderObject*)o len:(int)len {
    for (int i = 0; i < len; i++) {
        o.tex_pts[i] = fccp(o.tri_pts[i].x/o.texture.pixelsWide, o.tri_pts[i].y/o.texture.pixelsHigh);
    }
}

+(CGRect)ssrect_from_dict:(NSDictionary*)dict tar:(NSString*)tar {    
    NSDictionary *frames_dict = [dict objectForKey:@"frames"];
    NSDictionary *obj_info = [frames_dict objectForKey:tar];
    NSString *txt = [obj_info objectForKey:@"textureRect"];
    CGRect r = CGRectFromString(txt);
    return r;
}

+(CCAction*)make_anim_frames:(NSArray*)animFrames speed:(float)speed {
	id animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:speed] restoreOriginalFrame:YES];
    id m = [CCRepeatForever actionWithAction:animate];
	return m;
}

+(CGFloat) distanceBetween: (CGPoint)point1 and: (CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
}

+(CCMenuItem*)make_button_tex:(CCTexture2D*)tex seltex:(CCTexture2D*)seltex zscale:(float)zscale callback:(CallBack*)cb pos:(CGPoint)pos {
    CCSprite *img = [CCSprite spriteWithTexture:tex];
    CCSprite *img_zoom = [CCSprite spriteWithTexture:seltex];
    [Common set_zoom_pos_align:img zoomed:img_zoom scale:zscale];
    CCMenuItem* i = [CCMenuItemImage itemFromNormalSprite:img selectedSprite:img_zoom target:cb.target selector:cb.selector];
    [i setPosition:pos];
    return i;
}

+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale {
    zoomed.scale = scale;
    zoomed.position = ccp((-[zoomed contentSize].width * zoomed.scale + [zoomed contentSize].width)/2
                          ,(-[zoomed contentSize].height * zoomed.scale + [zoomed contentSize].height)/2);
}

+(CCLabelTTF*)cons_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize str:(NSString*)str {
    CCLabelTTF *l = [CCLabelTTF labelWithString:str fontName:@"Carton Six" fontSize:fontsize];
    [l setColor:color];
    [l setPosition:pos];
    return l;
}

+(void)transform_obj:(GLRenderObject*)o by:(CGPoint)position {
	o.tri_pts[0] = fccp(position.x+o.tri_pts[0].x, position.y+o.tri_pts[0].y);
	o.tri_pts[1] = fccp(position.x+o.tri_pts[1].x, position.y+o.tri_pts[1].y);
	o.tri_pts[2] = fccp(position.x+o.tri_pts[2].x, position.y+o.tri_pts[2].y);
	o.tri_pts[3] = fccp(position.x+o.tri_pts[3].x, position.y+o.tri_pts[3].y);
}

+(CameraZoom)cons_normalcoord_camera_zoom_x:(float)x y:(float)y z:(float)z {
    struct CameraZoom c = {x,y,z};
    [Common normal_to_gl_coord:&c];
    c.x += _TMP_X_OFFSET;
    c.z += _TMP_Z_OFFSET;
    return c;
}

+(void)normal_to_gl_coord:(CameraZoom*)glzd {
    //data:(280,230,50),(360,270,130),(600,410,400)
    float gwid = 0.907*(glzd->z)+237.819;
    float ghei = 0.515*(glzd->z)+203.696;
    gwid*=2;
    ghei*=2;
    
    float escrwid = [Common SCREEN].width;
    float escrhei = [Common SCREEN].height;
    
    float outx = (escrwid/2 - glzd->x)*(gwid/escrwid);
    float outy = (escrhei/2 - glzd->y)*(ghei/escrhei);
    
    glzd->x = outx;
    glzd->y = outy;
}

+(CGPoint)scale_from_default {
	return CGPointMake([Common SCREEN].width/480.0, [Common SCREEN].height/320.0);
}

+(CGPoint)pct_of_obj:(CCNode *)obj pctx:(float)pctx pcty:(float)pcty {
	CGRect rct = [obj boundingBoxInPixels];
	return ccp(rct.size.width*pctx,rct.size.height*pcty);
}

+(ccColor3B)color_from:(ccColor3B)a to:(ccColor3B)b pct:(float)pct {
	return ccc3(a.r+(b.r-a.r)*pct,a.g+(b.g-a.g)*pct,a.b+(b.b-a.b)*pct);
}

+(CCAction*)cons_anim:(NSArray*)a speed:(float)speed tex_key:(NSString*)key {
	CCTexture2D *texture = [Resource get_tex:key];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:key idname:k]]];
    return [Common make_anim_frames:animFrames speed:speed];
}

+(CCAction*)cons_nonrepeating_anim:(NSArray*)a speed:(float)speed tex_key:(NSString*)key {
	CCTexture2D *texture = [Resource get_tex:key];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:key idname:k]]];
	return [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:speed] restoreOriginalFrame:NO];
}

@end
