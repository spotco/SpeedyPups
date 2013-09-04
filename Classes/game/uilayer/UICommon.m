#import "UICommon.h"
#import "Common.h"
#import "GameEngineLayer.h"

@implementation UICommon
+(NSString*)parse_gameengine_time:(int)t {
    t*=20;
    return strf("%i:%i%i",t/60000,(t/10000)%6,(t/1000)%10);
}
+(CGPoint)player_approx_position:(GameEngineLayer*)game_engine_layer { //inverse of [Common normal_to_gl_coord]
    float outx = game_engine_layer.camera_state.x;
    float outy = game_engine_layer.camera_state.y;
    float outz = game_engine_layer.camera_state.z;
    float playerscrx = ([Common SCREEN].width/2.0)-outx/( (2*(0.907*outz + 237.819)) / ([Common SCREEN].width) );
    float playerscry = ([Common SCREEN].height/2.0)-outy/( (2*(0.515*outz + 203.696)) / ([Common SCREEN].height) );
    return ccp(playerscrx,playerscry);
}

+(CGPoint)pt_approx_position:(CGPoint)obj g:(GameEngineLayer*)g {
	CGPoint player_screen = [self player_approx_position:g];
	CGPoint world_delta = ccp(obj.x-g.player.position.x,obj.y-g.player.position.y);
	
	float outz = g.camera_state.z;
	//world_delta.x *= 0.64; //z = 160
	//world_delta.x *= 0.52; //z = 260
	world_delta.x *= (0.832- 0.0012 * outz);
	
	//TODO -- do y values too
	
	return CGPointAdd(player_screen, world_delta);
}

+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale {
    zoomed.scale = scale;
    zoomed.position = ccp((-[zoomed contentSize].width * zoomed.scale + [zoomed contentSize].width)/2
                          ,(-[zoomed contentSize].height * zoomed.scale + [zoomed contentSize].height)/2);
}
+(CCLabelTTF*)cons_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize{
    CCLabelTTF *l = [CCLabelTTF labelWithString:@"" fontName:@"Carton Six" fontSize:fontsize];
    [l setColor:color];
    [l setPosition:pos];
    [l setString:@"*"];
    return l;
}
+(CCMenuItemLabel*)label_cons_menuitem:(CCLabelTTF*)l leftalign:(BOOL)leftalign {
    CCMenuItemLabel *m = [CCMenuItemLabel itemWithLabel:l];
    if (leftalign) [m setAnchorPoint:ccp(0,m.anchorPoint.y)];
    return m;
}
+(CCMenuItem*)cons_menuitem_tex:(CCTexture2D*)tex pos:(CGPoint)pos {
    CCMenuItem* i = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:tex] selectedSprite:[CCSprite spriteWithTexture:tex]];
    [i setPosition:pos];
    return i;
}
+(void)button:(CCNode *)btn add_desctext:(NSString *)txt color:(ccColor3B)color fntsz:(int)fntsz {
	[btn addChild:[Common cons_label_pos:[Common pct_of_obj:btn pctx:0.5 pcty:-0.1]
										color:color
									 fontsize:fntsz
										  str:txt]];
}
@end
