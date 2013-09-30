#import "Lab2BGLayerSet.h"

@implementation Lab2BGLayerSet
+(Lab2BGLayerSet*)cons {
	Lab2BGLayerSet *rtv = [Lab2BGLayerSet node];
	return [rtv cons];
}

-(Lab2BGLayerSet*)cons {
	bg_objects = [NSMutableArray array];
	
	sky = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG2_SKY] scrollspd_x:0 scrollspd_y:0];
	[bg_objects addObject:sky];
	
	clouds = [[[CloudGenerator cons_texkey:TEX_BG2_CLOUDS_SS scaley:0.003] set_speedmult:0.3] set_generate_speed:140];
	[bg_objects addObject:clouds];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WINDOWWALL] scrollspd_x:0.01 scrollspd_y:0]];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WATER_BACK] scrollspd_x:0.06 scrollspd_y:0.0075]];
	tankers = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_TANKER_BACK] scrollspd_x:0.08 scrollspd_y:0.0125];
	[bg_objects addObject:tankers];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_DOCKS] scrollspd_x:0.08 scrollspd_y:0.02]];
	tankersfront = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_TANKER_FRONT] scrollspd_x:0.08 scrollspd_y:0.02];
	[bg_objects addObject:tankersfront];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WATER_FRONT] scrollspd_x:0.1 scrollspd_y:0.02]];
	
	
	BGTimeManager *time = [BGTimeManager cons];
	[time setVisible:NO];
	[bg_objects addObject:time];
	
	
	for (BackgroundObject *o in bg_objects) {
		[self addChild:o];
	}
	
	return self;
}

-(void)set_day_night_color:(float)val{
	float pctm = ((float)val) / 100;
	[sky setColor:PCT_CCC3(50,50,90,pctm)];
	[clouds setColor:PCT_CCC3(80, 80, 130, pctm)];
}

-(void)update:(GameEngineLayer*)g curx:(float)curx cury:(float)cury {
	for (BackgroundObject *o in bg_objects) {
		[o update_posx:curx posy:cury];
	}
	tankers_theta += 0.03 * [Common get_dt_Scale];
	tankers.position = CGPointAdd(ccp(0,sinf(tankers_theta)*2), tankers.position);
	tankersfront.position = CGPointAdd(ccp(0,cosf(tankers_theta)*2), tankersfront.position);
}
@end
