
#import "Resource.h"

@implementation Resource


static NSMutableDictionary* textures = nil;

+(void)cons_menu_textures:(NSArray *)pic_names{
    textures = [NSMutableDictionary dictionary];
    NSArray *temp = pic_names;
    [Resource load_tex_from_array:temp];
}

+(void)cons_textures {
    textures = [NSMutableDictionary dictionary];
    NSArray *temp = [[NSArray alloc] initWithObjects:
                        @"BG1_island_fill.png", TEX_GROUND_TEX_1,
                        @"BG1_top_fill.png", TEX_GROUND_TOP_1,
                        @"BG1_island_corner.png", TEX_GROUND_CORNER_TEX_1,
                        @"BG1_island_top_edge.png", TEX_TOP_EDGE,
                        @"BG1_bridge_edge.png",TEX_BRIDGE_EDGE,
                        @"BG1_bridge_section.png",TEX_BRIDGE_SECTION,
                     
                        @"lab_alarm.png",TEX_LAB_ALARM,
                        @"lab_bg.png",TEX_LAB_BG,
                        @"lab_ground_1.png",TEX_LAB_GROUND_1,
                        @"lab_ground_top.png",TEX_LAB_GROUND_TOP,
                        @"lab_ground_top_edge.png",TEX_LAB_GROUND_TOP_EDGE,
                        @"lab_pipe_1.png",TEX_LAB_PIPE_1,
                        @"lab_pipe_2.png",TEX_LAB_PIPE_2,
                        @"lab_island_corner.png",TEX_LAB_GROUND_CORNER,
                        @"back_labentrance_pillar.png",TEX_LAB_ENTRANCE_BACK,
                        @"front_labentrance_pillar.png",TEX_LAB_ENTRANCE_FORE,
                        @"ceil_labentrance.png",TEX_LAB_ENTRANCE_CEIL,
                        @"ceil_repeat_labentrance.png",TEX_LAB_ENTRANCE_CEIL_REPEAT,
                        @"lab_wall.png",TEX_LAB_WALL,

                        @"BG_cave_top_fill.png", TEX_CAVE_TOP_TEX,
                        @"BG_cave_top_edge.png", TEX_CAVE_CORNER_TEX,
                        @"BG_cave_wall.png", TEX_CAVEWALL,
                        @"BG_cave_rock_wall_base.png", TEX_CAVE_ROCKWALL_BASE,
                        @"BG_cave_rock_wall_section.png", TEX_CAVE_ROCKWALL_SECTION,
                        @"BG_cave_rock.png", TEX_CAVE_ROCKPARTICLE,
                        @"BG_cave_spike.png", TEX_CAVE_SPIKE,

                        @"BG1_sky.png", TEX_BG_SKY,
                        @"BG1_layer_1.png", TEX_BG_LAYER_1,
                        @"BG1_layer_2.png", TEX_BG_LAYER_2,
                        @"BG1_layer_3.png", TEX_BG_LAYER_3,
                        @"BG1_island_border.png", TEX_ISLAND_BORDER,
                        @"BG1_cloud.png", TEX_CLOUD,
                        @"water.png", TEX_WATER,
                        @"fish_ss.png", TEX_FISH_SS,
                        @"bird_ss.png", TEX_BIRD_SS,
                        @"superjump_ss.png", TEX_JUMPPAD,
                        @"speedup_ss.png", TEX_SPEEDUP,
                        @"startbanner_pole.png",TEX_STARTBANNER_POLE,
                        @"startbanner_banner.png",TEX_STARTBANNER_BANNER,
                        @"spike_vine_bottom.png", TEX_SPIKE_VINE_BOTTOM,
                        @"spike_vine_section.png", TEX_SPIKE_VINE_SECTION,
                     
                        @"swingvine_base.png", TEX_SWINGVINE_BASE,
                        @"swingvine_tex_loose.png", TEX_SWINGVINE_TEX,
                     
                        @"electric_body.png", TEX_ELECTRIC_BODY,
                        @"electric_post.png", TEX_ELECTRIC_BASE, 
                     
                        @"robot_default.png",TEX_ENEMY_ROBOT,
                        @"launcher_default.png",TEX_ENEMY_LAUNCHER,
                        @"rocket.png",TEX_ENEMY_ROCKET,
                        @"copter_default.png",TEX_ENEMY_COPTER,
                        @"robot_particle.png",TEX_ROBOT_PARTICLE,
                        @"explosion_default.png",TEX_EXPLOSION,
                        @"bomb.png",TEX_ENEMY_BOMB,
                                      
                        @"BG1_detail_1.png", TEX_GROUND_DETAIL_1,
                        @"BG1_detail_2.png", TEX_GROUND_DETAIL_2,
                        @"BG1_detail_3.png", TEX_GROUND_DETAIL_3,
                        @"BG1_detail_4.png", TEX_GROUND_DETAIL_4,
                        @"BG1_detail_5.png", TEX_GROUND_DETAIL_5,
                        @"BG1_detail_6.png", TEX_GROUND_DETAIL_6,
                        
                        @"lab_pipe_1.png", TEX_GROUND_DETAIL_7,
                        @"lab_pipe_2.png", TEX_GROUND_DETAIL_8,
                        @"lab_alarm.png", TEX_GROUND_DETAIL_9,      

                        @"dog1ss.png", TEX_DOG_RUN_1,
                        @"dog2ss.png", TEX_DOG_RUN_2,
                        @"dog3ss.png", TEX_DOG_RUN_3,
                        @"dog4ss.png", TEX_DOG_RUN_4,
                        @"dog5ss.png", TEX_DOG_RUN_5,
                        @"dog6ss.png", TEX_DOG_RUN_6,
                        @"dog7ss.png", TEX_DOG_RUN_7,
                        @"splash_ss.png", TEX_DOG_SPLASH,
                        @"dog_shadow.png", TEX_DOG_SHADOW,

                        @"goldenbone.png", TEX_GOLDEN_BONE,
                        @"star_coin.png", TEX_STARCOIN,
                        @"dogcape.png", TEX_DOG_CAPE,
                        @"dogrocket.png", TEX_DOG_ROCKET,
                        @"spikes.png", TEX_SPIKE,

                        @"checkpoint1.png",TEX_CHECKPOINT_1,
                        @"checkerfloor.png",TEX_CHECKERFLOOR,
                        @"checkpoint2.png",TEX_CHECKPOINT_2,

                        @"grey_particle.png",TEX_GREY_PARTICLE,
                        @"smokecloud.png",TEX_SMOKE_PARTICLE,
                        @"cannonfire_default.png", TEX_CANNONFIRE_PARTICLE,
                        @"cannontrail_default.png",TEX_CANNONTRAIL,
                     
                        @"ingame_ui_bone_icon.png",TEX_UI_BONE_ICON,
                        @"ingame_ui_lives_icon.png",TEX_UI_LIVES_ICON,
                        @"ingame_ui_time_icon.png",TEX_UI_TIME_ICON,
                        @"enemy_approach_ui.png",TEX_UI_ENEMY_ALERT,
                     
                        @"pauseicon.png", TEX_UI_PAUSEICON,
                        @"pause_menu_back.png", TEX_UI_PAUSEMENU_BACK,
                        @"pause_menu_play.png", TEX_UI_PAUSEMENU_PLAY,
                        @"pause_menu_return.png", TEX_UI_PAUSEMENU_RETURN,
                        @"gameover_title.png",TEX_UI_GAMEOVER_TITLE,
                        @"gameover_info.png",TEX_UI_GAMEOVER_INFO,
                        @"gameover_logo.png",TEX_UI_GAMEOVER_LOGO,

                        @"GO.png", TEX_UI_STARTGAME_GO,
                        @"READY.png", TEX_UI_STARTGAME_READY,

                        @"menu_select_dot_small.png",TEX_MENU_TEX_SELECTDOT_SMALL,
                        @"menu_back_button.png",TEX_MENU_TEX_BACKBUTTON,
                        @"menu_bg.png",TEX_MENU_BG,
                        @"menu_button_menu.png",TEX_MENU_BUTTON_MENU,
                        @"menu_button_playagain.png",TEX_MENU_BUTTON_PLAYAGAIN,
                        @"menu_current_character.png",TEX_MENU_CURRENT_CHARACTER,
                        @"menu_dog_mode_title.png",TEX_MENU_DOG_MODE_TITLE,
                        @"menu_gray_overlay.png",TEX_MENU_GRAY_OVERLAY,
                        @"menu_logo.png",TEX_MENU_LOGO,
                        @"menu_play_button.png",TEX_MENU_PLAYBUTTON,
                        @"menu_settings_button.png",TEX_MENU_SETTINGS_BUTTON,
                        @"menu_stats_title.png",TEX_MENU_STATS_TITLE,
                        @"menu_stats_button.png",TEX_MENU_STATS_BUTTON,
                        @"menu_settings_title.png",TEX_MENU_SETTINGS_TITLE,
                     
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
