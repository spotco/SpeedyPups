
#import "Resource.h"

@implementation Resource


static NSDictionary* all_textures;
static NSMutableDictionary* loaded_textures;

+(void)initialize {
	loaded_textures = [NSMutableDictionary dictionary];
	all_textures = @{
		TEX_GROUND_TEX_1 : @"BG1_island_fill.png",
		TEX_GROUND_TOP_1 : @"BG1_top_fill.png",
		TEX_GROUND_CORNER_TEX_1 : @"BG1_island_corner.png",
		TEX_TOP_EDGE : @"BG1_island_top_edge.png",
		TEX_BRIDGE_EDGE : @"BG1_bridge_edge.png",
		TEX_BRIDGE_SECTION : @"BG1_bridge_section.png",
		TEX_GROUND_DETAILS : @"grounddetail_ss.png",
		TEX_LAB_BG : @"lab_bg.png",
		TEX_LAB_GROUND_1 : @"lab_ground_1.png",
		TEX_LAB_GROUND_TOP : @"lab_ground_top.png",
		TEX_LAB_GROUND_TOP_EDGE : @"lab_ground_top_edge.png",
		TEX_LAB_GROUND_CORNER : @"lab_island_corner.png",
		TEX_LAB_ENTRANCE_BACK : @"back_labentrance_pillar.png",
		TEX_LAB_ENTRANCE_FORE : @"front_labentrance_pillar.png",
		TEX_LAB_ENTRANCE_CEIL : @"ceil_labentrance.png",
		TEX_LAB_ENTRANCE_CEIL_REPEAT:@"ceil_repeat_labentrance.png",
		TEX_LAB_WALL:@"lab_wall.png",
		TEX_LAB_BG_LAYER:@"lab_bg_layer.png",
		TEX_LAB_ROCK_PARTICLE:@"lab_rock_particle.png",
		TEX_CAVE_TOP_TEX:@"BG_cave_top_fill.png",
		TEX_CAVE_CORNER_TEX:@"BG_cave_top_edge.png",
		TEX_CAVEWALL:@"BG_cave_wall.png",
		TEX_CAVE_ROCKWALL_BASE:@"breakablewall_base.png",
		TEX_CAVE_ROCKWALL_SECTION:@"breakablewall_body.png",
		TEX_LAB_ROCKWALL_BASE:@"labbreakablewall_base.png",
		TEX_LAB_ROCKWALL_SECTION:@"labbreakablewall_body.png",
		TEX_CAVE_ROCKPARTICLE:@"rock_particle.png",
		TEX_BG_SKY:@"BG1_sky.png",
		TEX_BG_SUN:@"BG1_sun.png",
		TEX_BG_MOON:@"BG1_moon.png",
		TEX_BG_STARS:@"BG1_stars.png",
		TEX_BG_LAYER_1:@"BG1_layer_1.png",
		TEX_BG_LAYER_3:@"BG1_layer_3.png",
		TEX_ISLAND_BORDER:@"BG1_island_border.png",
		TEX_CLOUD_SS:@"cloud_ss.png",
		TEX_WATER:@"water.png",
		TEX_FISH_SS:@"fish_ss.png",
		TEX_BIRD_SS:@"bird_ss.png",
		TEX_JUMPPAD:@"jumppad.png",
		TEX_SPEEDUP:@"speedup_ss.png",
		TEX_SPIKE_VINE_BOTTOM:@"spike_vine_bottom.png",
		TEX_SPIKE_VINE_SECTION:@"spike_vine_section.png",
		TEX_GOAL_SS:@"goal_ss.png",
		TEX_PARTICLE_1UP:@"1up.png",
		TEX_SWINGVINE_BASE:@"swingvine_base.png",
		TEX_SWINGVINE_TEX:@"swingvine_tex_loose.png",
		TEX_LABSWINGVINE_BASE:@"labswingvine_base.png",
		TEX_ELECTRIC_BODY:@"electric_body.png",
		TEX_ELECTRIC_BASE:@"electric_post.png",
		TEX_ITEM_SS:@"item_ss.png",
		TEX_ENEMY_ROBOT:@"robot_default.png",
		TEX_ENEMY_LAUNCHER:@"launcher_default.png",
		TEX_ENEMY_ROCKET:@"rocket.png",
		TEX_ENEMY_COPTER:@"copter_default.png",
		TEX_ROBOT_PARTICLE:@"robot_particle.png",
		TEX_EXPLOSION:@"explosion_default.png",
		TEX_ENEMY_BOMB:@"bomb.png",
		TEX_DOG_RUN_1:@"dog1ss.png",
		TEX_DOG_RUN_2:@"dog2ss.png",
		TEX_DOG_RUN_3:@"dog3ss.png",
		TEX_DOG_RUN_4:@"dog4ss.png",
		TEX_DOG_RUN_5:@"dog5ss.png",
		TEX_DOG_RUN_6:@"dog6ss.png",
		TEX_DOG_RUN_7:@"dog7ss.png",
		TEX_DOG_SPLASH:@"splash_ss.png",
		TEX_DOG_SHADOW:@"dog_shadow.png",
		TEX_DOG_ARMORED:@"armored_dog_ss.png",
		TEX_SWEATANIM_SS:@"sweatanim_ss.png",
		TEX_DASHJUMPPARTICLES_SS:@"dashjumpparticles_ss.png",
		TEX_ONEUP_OBJECT:@"1upobject.png",
		TEX_GOLDEN_BONE:@"goldenbone.png",
		TEX_STARCOIN:@"star_coin.png",
		TEX_DOG_CAPE:@"dogcape.png",
		TEX_DOG_ROCKET:@"dogrocket.png",
		TEX_SPIKE:@"spikes.png",
		TEX_CHECKPOINT_1:@"checkpoint1.png",
		TEX_CHECKPOINT_2:@"checkpoint2.png",
		TEX_GREY_PARTICLE:@"grey_particle.png",
		TEX_SMOKE_PARTICLE:@"smokecloud.png",
		TEX_CANNONFIRE_PARTICLE:@"cannonfire_default.png",
		TEX_CANNONTRAIL:@"cannontrail_default.png",
		TEX_UI_INGAMEUI_SS:@"ingame_ui_ss.png",
		TEX_TUTORIAL_OBJ:@"tutorial_obj.png",
		TEX_TUTORIAL_ANIM_1:@"tut_anim_1.png",
		TEX_TUTORIAL_ANIM_2:@"tut_anim_2.png",
		TEX_NMENU_LOGO:@"logo_ss.png",
		TEX_NMENU_ITEMS:@"nmenu_items.png",
		TEX_NMENU_BG:@"nmenu_bg.png",
		TEX_NMENU_DOGHOUSEMASK:@"doghouse_mask.png",
		TEX_NMENU_LEVELSELOBJ:@"nmenu_levelselectobj.png",
		TEX_FREERUNSTARTICONS:@"freerunstart_icons.png",
		TEX_BLANK:@"blank.png"
	};
	[self load_all];
}

+(void)load_all {
	for (NSString *key in all_textures) {
		CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:all_textures[key]];
		[tex setAntiAliasTexParameters];
		loaded_textures[key] = tex;
	}
}

+(CCTexture2D*)get_tex:(NSString *)key {
	if (loaded_textures[key] != nil) {
		return loaded_textures[key];
	} else {
		CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:all_textures[key]];
		[tex setAntiAliasTexParameters];
		loaded_textures[key] = tex;
		NSLog(@"loading:%@",all_textures[key]);
		return loaded_textures[key];
	}
}

+(void)unload_textures {
	[loaded_textures removeAllObjects];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}



@end
