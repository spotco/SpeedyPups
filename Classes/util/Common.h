#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Vec3D.h"

long sys_time();
float drp(float a, float b, float div);
float lerp(float a, float b, float t);
#define NSVEnum(val,type) [NSValue value:&val withObjCType:@encode(type)]

@interface CCSprite_VerboseDealloc : CCSprite
@end

@interface NSArray (Random)
	-(id)random;
	-(NSArray*)copy_removing:(NSArray*)a;
	-(BOOL)contains_str:(NSString*)tar;
	-(id)get:(int)i;
@end
@implementation NSArray (Random)
	-(id)random {
		uint32_t rnd = (uint32_t)arc4random_uniform([self count]);
		return [self objectAtIndex:rnd];
	}
	-(BOOL)contains_str:(NSString *)tar {
		for (id i in self) {
			if ([i isEqualToString:tar]) return YES;
		}
		return NO;
	}
	-(NSArray*)copy_removing:(NSArray *)a {
		NSMutableArray *n = [NSMutableArray array];
		for (id i in self) {
			if (![a containsObject:i]) [n addObject:i];
		}
		return n;
	}
	-(id)get:(int)i {
		if (i >= [self count]) {
			//NSLog(@"error getting nsarray[%d] (size %d)",i,self.count);
			return NULL;
		} else {
			return [self objectAtIndex:i];
		}
	}
@end

@interface NSMutableArray (Shuffle)
	-(void)shuffle;
@end

@implementation NSMutableArray (Shuffle)
	-(void)shuffle {
		for (NSUInteger i = [self count] - 1; i >= 1; i--){
			u_int32_t j = (uint32_t)arc4random_uniform(i + 1);
			[self exchangeObjectAtIndex:j withObjectAtIndex:i];
		}
	}
@end

#define float_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)
#define arrlen(x)  (sizeof(x) / sizeof(x[0]))
#define streq(a,b) [a isEqualToString:b]
#define DO_FOR(cts,a) for(int i = 0; i < cts; i++) { a; }

#define _NSSET(...)  [NSMutableSet setWithArray:@[__VA_ARGS__]]
#define _NSMARRAY(...)  [NSMutableArray arrayWithArray:@[__VA_ARGS__]]

//inclusive s, not l
#define int_random(s,l) arc4random()%l+s

@class PlayerEffectParams;
@class Island;
@class SwingVine;
@class Cannon;
@protocol PhysicsObject <NSObject>
    @property(readwrite,assign) float vx,vy,scaleX,scaleY,rotation;
    @property(readwrite,assign) int last_ndir, movedir;
    @property(readwrite,assign) Vec3D up_vec;
    @property(readwrite,assign) BOOL floating;
    @property(readwrite,assign) CGPoint position;

	@property(readwrite,unsafe_unretained) Island* current_island;
    @property(readwrite,unsafe_unretained) SwingVine* current_swingvine;
	@property(readwrite,unsafe_unretained) Cannon* current_cannon;

	-(PlayerEffectParams*)get_current_params;
    -(int)get_speed;
@end

@interface CallBack : NSObject
@property(readwrite,assign) SEL selector;
@property(readwrite,unsafe_unretained) NSObject *target;
@end

typedef struct _fCGPoint {
	float x;
	float y;
} fCGPoint; //64bit opengl PLS USE FLOATS

fCGPoint fCGPointMake(float x, float y);
#define fccp(x,y) fCGPointMake(x, y)
#define ccp2fccp(p) fCGPointMake(p.x,p.y)
#define fccp2ccp(p) CGPointMake(p.x,p.y)


@interface GLRenderObject : NSObject {
        fCGPoint tri_pts[4];
        fCGPoint tex_pts[4];
    }

    @property(readwrite,unsafe_unretained) CCTexture2D* texture;
    @property(readwrite,assign) int isalloc,pts;
    -(fCGPoint*)tri_pts;
    -(fCGPoint*)tex_pts;
@end

@interface TexRect : NSObject
@property(readwrite,unsafe_unretained) CCTexture2D* tex;
@property(readwrite,assign) CGRect rect;
+(TexRect*)cons_tex:(CCTexture2D*)tex rect:(CGRect)rect;
@end

@interface CCLabelTTF_Pooled : CCLabelTTF
-(void)repool;
@end

@interface Common : NSObject

typedef struct HitRect {
    float x1,y1,x2,y2;
} HitRect;

typedef struct line_seg {
    CGPoint a;
    CGPoint b;
} line_seg;

typedef struct CameraZoom {
    float x;
    float y;
    float z;
} CameraZoom;

typedef struct CGRange {
    float min,max;
} CGRange;

NSString* strf (char* format, ... );
int SIG(float n);
int pb(int base,float pctm);
ccColor3B PCT_CCC3(int _R,int _G,int _B,float _PCTM);
CGPoint CGPointAdd(CGPoint a,CGPoint b);
float CGPointDist(CGPoint a,CGPoint b);

+(void)set_dt:(ccTime)dt;
+(float)get_dt_Scale;
+(void)unset_dt;

+(CGSize)SCREEN;
+(CGPoint)screen_pctwid:(float)pctwid pcthei:(float)pcthei;

+(void)run_callback:(CallBack*)c;
+(CallBack*)cons_callback:(NSObject*)tar sel:(SEL)sel;
+(void)print_hitrect:(HitRect)l msg:(NSString*)msg;
+(CGPoint)line_seg_intersection_a1:(CGPoint)a1 a2:(CGPoint)a2 b1:(CGPoint)b1 b2:(CGPoint)b2;
+(CGPoint)line_seg_intersection_a:(line_seg)a b:(line_seg)b;
+(line_seg)cons_line_seg_a:(CGPoint)a b:(CGPoint)b;
+(void)print_line_seg:(line_seg)l msg:(NSString*)msg;
+(BOOL)point_fuzzy_on_line_seg:(line_seg)seg pt:(CGPoint)pt;
+(BOOL)pt_fuzzy_eq:(CGPoint)a b:(CGPoint)b;
+(BOOL)fuzzyeq_a:(float)a b:(float)b delta:(float)delta;
+(BOOL)hitrect_touch:(HitRect)r1 b:(HitRect)r2;
+(NSString*)hitrect_to_string:(HitRect)r;

+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;
+(HitRect)hitrect_cons_x1:(float)x1 y1:(float)y1 wid:(float)wid hei:(float)hei;
+(CGPoint*)hitrect_get_pts:(HitRect)rect;
+(CGRect)hitrect_to_cgrect:(HitRect)rect;

+(float)shortest_dist_from_cur:(float)a1 to:(float)a2;

+(float)deg_to_rad:(float)degrees;
+(float)rad_to_deg:(float)rad;
+(float)sig:(float)n;

+(void)draw_renderobj:(GLRenderObject*)obj n_vtx:(int)n_vtx;
+(void)transform_obj:(GLRenderObject*)o by:(CGPoint)position ;
+(void)tex_map_to_tri_loc:(GLRenderObject*)o len:(int)len;
+(GLRenderObject*)neu_cons_render_obj:(CCTexture2D*)tex npts:(int)npts;
+(GLRenderObject*)cons_render_obj:(CCTexture2D*)tex npts:(int)npts obj:(GLRenderObject*)obj;

+(CGRect)ssrect_from_dict:(NSDictionary*)dict tar:(NSString*)tar;
+(id)make_anim_frames:(NSArray*)animFrames speed:(float)speed;
+(CGFloat) distanceBetween: (CGPoint)point1 and: (CGPoint)point2;

+(CCMenuItem*)make_button_tex:(CCTexture2D*)tex seltex:(CCTexture2D*)seltex zscale:(float)zscale callback:(CallBack*)cb pos:(CGPoint)pos;
+(CCLabelTTF*)cons_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize str:(NSString*)str;
+(CCLabelTTF_Pooled*)cons_pooled_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize str:(NSString*)str;

+(CameraZoom)cons_normalcoord_camera_zoom_x:(float)x y:(float)y z:(float)z;

+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale;

+(CGPoint)scale_from_default;
+(CGPoint)pct_of_obj:(CCNode*)obj pctx:(float)pctx pcty:(float)pcty;

+(ccColor3B)color_from:(ccColor3B)a to:(ccColor3B)b pct:(float)pct;

+(CCAction*)cons_anim:(NSArray*)a speed:(float)speed tex_key:(NSString*)key;
+(CCAction*)cons_nonrepeating_anim:(NSArray*)a speed:(float)speed tex_key:(NSString*)key;

+(BOOL)force_compress_textures;

+(BOOL)is_visible:(CCNode*)tar;
@end
