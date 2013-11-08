#import "cocos2d.h"
#import "DataStore.h"
#import "Island.h"
#import "Player.h"
#import "DogShadow.h"
#import "Common.h"
#import "GameObject.h"
#import "Particle.h"
#import "GEventDispatcher.h"
@class BGLayer;
@class UILayer;
#import "GameEngineStats.h" 
#import "Resource.h"
#import "MapLoader.h"
#import "GamePhysicsImplementation.h"
#import "GameRenderImplementation.h"
#import "GameControlImplementation.h"
#import "AutoLevel.h"
#import "World1ParticleGenerator.h"
#import "BatchDraw.h"
#import "Challenge.h"
#import "GameWorldMode.h"

#define GAMEENGINE_INF_LIVES -99

typedef enum {
    GameEngineLayerMode_SCROLLDOWN,
    GameEngineLayerMode_RUNINANIM,
    GameEngineLayerMode_CAMERAFOLLOWTICK,
    GameEngineLayerMode_GAMEPLAY,
    GameEngineLayerMode_PAUSED,
    GameEngineLayerMode_UIANIM,
    GameEngineLayerMode_GAMEOVER,
    GameEngineLayerMode_RUNOUT,
	GameEngineLayerMode_CAPEOUT,
	GameEngineLayerMode_CAPEIN
} GameEngineLayerMode;

@interface GameEngineLayer : CCLayer <GEventListener> {
    NSMutableArray *particles,*particles_tba, *gameobjects_tbr;
    
    int lives;
    float time;
    int collected_bones;
    int current_continue_cost;
    int default_starting_lives;
    int collected_secrets;
    
    int runout_ct;
    ChallengeInfo* challenge;
    
    BOOL refresh_viewbox_cache;
    HitRect cached_viewbox;
    BOOL refresh_worldbounds_cache;
    HitRect cached_worldsbounds;
    
    CGPoint player_starting_pos;
    BOOL do_runin_anim;
    float scrollup_pct,defcey;
	
	//BGMode cur_bg_mode;
	
	float follow_clamp_y_min,follow_clamp_y_max;
	float actual_follow_clamp_y_min,actual_follow_clamp_y_max;
	
	GameEngineStats *stats;
	
	GameEngineLayerMode stored_mode;
	//WorldNum cur_world_num;
	//LabNum cur_lab_num;
}


@property(readwrite,assign) GameEngineLayerMode current_mode;
@property(readwrite,strong) NSMutableArray *islands, *game_objects;
@property(readwrite,strong) Player *player;
@property(readwrite,assign) CameraZoom camera_state,tar_camera_state;

+(CCScene*)scene_with:(NSString *)map_file_name lives:(int)lives world:(WorldNum)world;
+(CCScene*)scene_with_autolevel_lives:(int)lives world:(WorldNum)world;
+(CCScene*)scene_with_challenge:(ChallengeInfo*)info world:(WorldNum)world;

-(UILayer*)get_ui_layer;
-(BGLayer*)get_bg_layer;

-(ChallengeInfo*)get_challenge;

/*
-(BGMode)get_cur_bg_mode;
-(WorldNum)get_world_num;
-(LabNum)get_lab_num;
*/
 
-(CGRange)get_follow_clamp_y_range;
-(CGRange)get_actual_follow_clamp_y_range;

-(void)add_particle:(Particle*)p;
-(void)add_gameobject:(GameObject*)o;
-(void)remove_gameobject:(GameObject*)o;

-(HitRect)get_viewbox;
-(HitRect)get_world_bounds;

-(void)set_camera:(CameraZoom)tar;
-(void)set_target_camera:(CameraZoom)tar;

-(void)follow_player;

-(void)collect_bone:(BOOL)do_1up_anim;

-(int)get_lives;
-(int)get_time;
-(int)get_num_particles;
-(int)get_num_bones;
-(int)get_num_secrets;

-(void)incr_lives;
-(void)incr_time:(float)t;

-(int)get_current_continue_cost;
-(void)incr_current_continue_cost;

-(void)frame_set_follow_clamp_y_min:(float)min max:(float)max;

-(void)setColor:(ccColor3B)color;

-(GameEngineStats*)get_stats;

@end
