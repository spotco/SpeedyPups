#import "cocos2d.h"

@interface Resource : NSObject

+(void)cons_textures;
+(CCTexture2D*)get_tex:(NSString*)key;
+(void)dealloc_textures;

#define TEX_GROUND_TEX_1 @"GroundTexture1"
#define TEX_GROUND_TOP_1 @"GroundTop1"
#define TEX_GROUND_CORNER_TEX_1 @"ground_1_corner"
#define TEX_BRIDGE_EDGE @"BridgeEdge"
#define TEX_BRIDGE_SECTION @"BridgeSection"
#define TEX_TOP_EDGE @"GroundTopEdge"

#define TEX_GROUND_DETAILS @"grounddetail_ss"

#define TEX_LAB_BG @"labbg"
#define TEX_LAB_GROUND_1 @"labground1"
#define TEX_LAB_GROUND_TOP @"labgroundtop"
#define TEX_LAB_GROUND_TOP_EDGE @"labgroundtopedge"
#define TEX_LAB_GROUND_CORNER @"labgroundcorner"
#define TEX_LAB_ENTRANCE_BACK @"labentranceback"
#define TEX_LAB_ENTRANCE_FORE @"labentrancefore"
#define TEX_LAB_ENTRANCE_CEIL @"labentranceceil"
#define TEX_LAB_ENTRANCE_CEIL_REPEAT @"labentranceceilrepeat"
#define TEX_LAB_WALL @"labwall"
#define TEX_LAB_BG_LAYER @"lab_bg_layer"

#define TEX_CAVE_TOP_TEX @"CaveTopTex"
#define TEX_CAVE_CORNER_TEX @"CaveCornerTex"
#define TEX_CAVEWALL @"CaveWall"
#define TEX_CAVE_ROCKWALL_BASE @"RockWallBase"
#define TEX_CAVE_ROCKWALL_SECTION @"RockWallSection"
#define TEX_LAB_ROCKWALL_BASE @"LabRockWallBase"
#define TEX_LAB_ROCKWALL_SECTION @"LabRockWallSection"
#define TEX_CAVE_ROCKPARTICLE @"RockParticle"

#define TEX_DOG_RUN_1 @"dog1ss"
#define TEX_DOG_RUN_2 @"dog2ss"
#define TEX_DOG_RUN_3 @"dog3ss"
#define TEX_DOG_RUN_4 @"dog4ss"
#define TEX_DOG_RUN_5 @"dog5ss"
#define TEX_DOG_RUN_6 @"dog6ss"
#define TEX_DOG_RUN_7 @"dog7ss"
#define TEX_DOG_SPLASH @"splash_ss"
#define TEX_DOG_SHADOW @"dogshadow"
#define TEX_DOG_ARMORED @"armored_dog_ss"
#define TEX_SWEATANIM_SS @"sweatanim_ss"

#define TEX_ISLAND_BORDER @"IslandBorder"
#define TEX_CLOUD_SS @"cloud_ss"

#define TEX_GOAL_SS @"goal_ss"

#define TEX_BG_SKY @"BgSky"
#define TEX_BG_SUN @"BgSun"
#define TEX_BG_MOON @"BgMoon"
#define TEX_BG_STARS @"BgStars"
#define TEX_BG_LAYER_1 @"BgLayer1"
#define TEX_BG_LAYER_3 @"BgLayer3"
#define TEX_GOLDEN_BONE @"GoldenBone"
#define TEX_STARCOIN @"StarCoin"
#define TEX_DOG_CAPE @"DogCape"
#define TEX_DOG_ROCKET @"DogRocket"
#define TEX_SPIKE @"Spike"
#define TEX_WATER @"Water"
#define TEX_FISH_SS @"fish_ss"
#define TEX_BIRD_SS @"bird_ss"
#define TEX_JUMPPAD @"jumppad"
#define TEX_SPEEDUP @"speedup_ss"
#define TEX_SPIKE_VINE_BOTTOM @"SpikeVineRight"
#define TEX_SPIKE_VINE_SECTION @"SpikeVineSection"

#define TEX_PARTICLE_1UP @"1up"

#define TEX_ITEM_SS @"item_ss"

#define TEX_ENEMY_ROBOT @"robot_default"
#define TEX_ENEMY_LAUNCHER @"launcher_default"
#define TEX_ENEMY_ROCKET @"rocket"
#define TEX_ENEMY_COPTER @"copter_default"
#define TEX_ROBOT_PARTICLE @"robot_particle"
#define TEX_EXPLOSION @"explosion_default"
#define TEX_ENEMY_BOMB @"bomb"

#define TEX_SWINGVINE_BASE @"SwingVineBase"
#define TEX_SWINGVINE_TEX @"SwingVineTex"
#define TEX_LABSWINGVINE_BASE @"LABSwingVineBase"

#define TEX_ELECTRIC_BODY @"electricbody"
#define TEX_ELECTRIC_BASE @"electricbase"

#define TEX_CHECKPOINT_1 @"CheckPointPre"
#define TEX_CHECKPOINT_2 @"CheckPointPost"

#define TEX_GREY_PARTICLE @"GreyParticle"
#define TEX_SMOKE_PARTICLE @"smokeparticle"
#define TEX_CANNONFIRE_PARTICLE @"cannonfire_default"
#define TEX_CANNONTRAIL @"cannontrail_default"

#define TEX_UI_BONE_ICON @"UIBoneIcon"
#define TEX_UI_LIVES_ICON @"UILivesIcon"
#define TEX_UI_TIME_ICON @"UITimeIcon"
#define TEX_UI_ENEMY_ALERT @"UIEnemyAlert"

#define TEX_UI_PAUSEICON @"UIPauseIcon"
#define TEX_UI_STARTGAME_GO @"UIStartGameGo"
#define TEX_UI_STARTGAME_READY @"UIStartGameReady"

#define TEX_UI_INGAMEUI_SS @"ingame_ui_ss"

#define TEX_TUTORIAL_OBJ @"tutorial_obj"
#define TEX_TUTORIAL_ANIM_1 @"tut_anim_1"
#define TEX_TUTORIAL_ANIM_2 @"tut_anim_2"

#define TEX_NMENU_ITEMS @"nmenu_items"
#define TEX_NMENU_BG @"nmenu_bg"
#define TEX_NMENU_DOGHOUSEMASK @"doghousemask"
#define TEX_NMENU_LOGO @"logo_ss"
#define TEX_NMENU_LEVELSELOBJ @"nmenu_levelselectobj"

#define TEX_BLANK @"blank"

@end
