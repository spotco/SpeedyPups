
#import "Resource.h"

@implementation Resource


static NSMutableDictionary* textures = nil;

+(void)cons_textures {
    textures = [NSMutableDictionary dictionary];
    NSArray *temp = [[NSArray alloc] initWithObjects:
                        @"BG1_island_fill.png", TEX_GROUND_TEX_1,
                        @"BG1_top_fill.png", TEX_GROUND_TOP_1,
                        @"BG1_island_corner.png", TEX_GROUND_CORNER_TEX_1,
                        @"BG1_island_top_edge.png", TEX_TOP_EDGE,
                        @"BG1_bridge_edge.png",TEX_BRIDGE_EDGE,
                        @"BG1_bridge_section.png",TEX_BRIDGE_SECTION,
                     
                        @"grounddetail_ss.png",TEX_GROUND_DETAILS,
                     
                        @"lab_bg.png",TEX_LAB_BG,
                        @"lab_ground_1.png",TEX_LAB_GROUND_1,
                        @"lab_ground_top.png",TEX_LAB_GROUND_TOP,
                        @"lab_ground_top_edge.png",TEX_LAB_GROUND_TOP_EDGE,
                        @"lab_island_corner.png",TEX_LAB_GROUND_CORNER,
                        @"back_labentrance_pillar.png",TEX_LAB_ENTRANCE_BACK,
                        @"front_labentrance_pillar.png",TEX_LAB_ENTRANCE_FORE,
                        @"ceil_labentrance.png",TEX_LAB_ENTRANCE_CEIL,
                        @"ceil_repeat_labentrance.png",TEX_LAB_ENTRANCE_CEIL_REPEAT,
                        @"lab_wall.png",TEX_LAB_WALL,
												@"lab_bg_layer.png",TEX_LAB_BG_LAYER,
                     
                        @"checkerboard_texture.png",TEX_CHECKERBOARD,

                        @"BG_cave_top_fill.png", TEX_CAVE_TOP_TEX,
                        @"BG_cave_top_edge.png", TEX_CAVE_CORNER_TEX,
                        @"BG_cave_wall.png", TEX_CAVEWALL,
                     
                        @"breakablewall_base.png", TEX_CAVE_ROCKWALL_BASE,
                        @"breakablewall_body.png", TEX_CAVE_ROCKWALL_SECTION,
                        @"rock_particle.png", TEX_CAVE_ROCKPARTICLE,

                        @"BG1_sky.png", TEX_BG_SKY,
                        @"BG1_sun.png", TEX_BG_SUN,
                        @"BG1_moon.png", TEX_BG_MOON,
                        @"BG1_stars.png",TEX_BG_STARS,
                        @"BG1_layer_1.png", TEX_BG_LAYER_1,
                        @"BG1_layer_3.png", TEX_BG_LAYER_3,
                        @"BG1_island_border.png", TEX_ISLAND_BORDER,
												
												@"cloud_ss.png", TEX_CLOUD_SS,
										 
                        @"water.png", TEX_WATER,
                        @"fish_ss.png", TEX_FISH_SS,
                        @"bird_ss.png", TEX_BIRD_SS,
                        @"jumppad.png", TEX_JUMPPAD,
                        @"speedup_ss.png", TEX_SPEEDUP,
                        @"startbanner_pole.png",TEX_STARTBANNER_POLE,
                        @"startbanner_banner.png",TEX_STARTBANNER_BANNER,
                        @"spike_vine_bottom.png", TEX_SPIKE_VINE_BOTTOM,
                        @"spike_vine_section.png", TEX_SPIKE_VINE_SECTION,
                     
                        @"1up.png",TEX_PARTICLE_1UP,
                     
                        @"swingvine_base.png", TEX_SWINGVINE_BASE,
                        @"swingvine_tex_loose.png", TEX_SWINGVINE_TEX,
                     
                        @"electric_body.png", TEX_ELECTRIC_BODY,
                        @"electric_post.png", TEX_ELECTRIC_BASE,
                        @"item_ss.png",TEX_ITEM_SS,
                     
                        @"robot_default.png",TEX_ENEMY_ROBOT,
                        @"launcher_default.png",TEX_ENEMY_LAUNCHER,
                        @"rocket.png",TEX_ENEMY_ROCKET,
                        @"copter_default.png",TEX_ENEMY_COPTER,
                        @"robot_particle.png",TEX_ROBOT_PARTICLE,
                        @"explosion_default.png",TEX_EXPLOSION,
                        @"bomb.png",TEX_ENEMY_BOMB,

                        @"dog1ss.png", TEX_DOG_RUN_1,
                        @"dog2ss.png", TEX_DOG_RUN_2,
                        @"dog3ss.png", TEX_DOG_RUN_3,
                        @"dog4ss.png", TEX_DOG_RUN_4,
                        @"dog5ss.png", TEX_DOG_RUN_5,
                        @"dog6ss.png", TEX_DOG_RUN_6,
                        @"dog7ss.png", TEX_DOG_RUN_7,
                        @"splash_ss.png", TEX_DOG_SPLASH,
                        @"dog_shadow.png", TEX_DOG_SHADOW,
                        @"armored_dog_ss.png", TEX_DOG_ARMORED,

                        @"goldenbone.png", TEX_GOLDEN_BONE,
                        @"star_coin.png", TEX_STARCOIN,
                        @"dogcape.png", TEX_DOG_CAPE,
                        @"dogrocket.png", TEX_DOG_ROCKET,
                        @"spikes.png", TEX_SPIKE,

                        @"checkpoint1.png",TEX_CHECKPOINT_1,
                        @"checkpoint2.png",TEX_CHECKPOINT_2,

                        @"grey_particle.png",TEX_GREY_PARTICLE,
                        @"smokecloud.png",TEX_SMOKE_PARTICLE,
                        @"cannonfire_default.png", TEX_CANNONFIRE_PARTICLE,
                        @"cannontrail_default.png",TEX_CANNONTRAIL,
                     
                        @"ingame_ui_bone_icon.png",TEX_UI_BONE_ICON,
                        @"ingame_ui_lives_icon.png",TEX_UI_LIVES_ICON,
                        @"ingame_ui_time_icon.png",TEX_UI_TIME_ICON,
                        @"enemy_approach_ui.png",TEX_UI_ENEMY_ALERT,
                     
                        @"ingame_ui_ss.png",TEX_UI_INGAMEUI_SS,
                     
                        @"pauseicon.png", TEX_UI_PAUSEICON,

                        @"GO.png", TEX_UI_STARTGAME_GO,
                        @"READY.png", TEX_UI_STARTGAME_READY,
                     
                        @"tutorial_obj.png", TEX_TUTORIAL_OBJ,
                        @"tut_anim_1.png", TEX_TUTORIAL_ANIM_1,
                        @"tut_anim_2.png", TEX_TUTORIAL_ANIM_2,
                     
                        @"logo_ss.png",TEX_NMENU_LOGO,
                     
                        @"nmenu_items.png",TEX_NMENU_ITEMS,
                        @"nmenu_bg.png",TEX_NMENU_BG,
                        @"doghouse_mask.png",TEX_NMENU_DOGHOUSEMASK,
                        @"nmenu_levelselectobj.png",TEX_NMENU_LEVELSELOBJ,
                     
                        @"blank.png",TEX_BLANK,
                     
                     nil];
    [Resource load_tex_from_array:temp];
}

+(void)load_tex_from_array:(NSArray*)temp {
    ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT };
    for(int i = 0; i < [temp count]-1; i+=2) {
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:[temp objectAtIndex:i]];
        
        [textures setObject:tex forKey:[temp objectAtIndex:(i+1)]];
        [tex setTexParameters: &texParams];
    }
}

+(CCTexture2D*)get_tex:(NSString*)key {
    CCTexture2D* ret = [textures objectForKey:key];
    if (!ret) {
        NSLog(@"Failed to get texture %@",key);
    }
    return ret;
}

+(CCTexture2D*)get_aa_tex:(NSString*)key {
    CCTexture2D* tex = [Resource get_tex:key];
    [tex setAntiAliasTexParameters];
    ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT };
    [tex setTexParameters:&texParams];
    return tex;
}

+(void)dealloc_textures {
    [textures removeAllObjects];
    [[CCTextureCache sharedTextureCache] removeAllTextures];    
}



@end
