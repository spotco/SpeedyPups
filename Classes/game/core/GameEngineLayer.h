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
#import "Resource.h"
#import "MapLoader.h"
#import "GamePhysicsImplementation.h"
#import "GameRenderImplementation.h"
#import "GameControlImplementation.h"
#import "AutoLevel.h"
#import "World1ParticleGenerator.h"
#import "BatchDraw.h"
#import "Challenge.h" 

#define GAMEENGINE_INF_LIVES -99

typedef enum {
    GameEngineLayerMode_SCROLLDOWN,
    GameEngineLayerMode_RUNINANIM,
    GameEngineLayerMode_CAMERAFOLLOWTICK,
    GameEngineLayerMode_GAMEPLAY,
    GameEngineLayerMode_PAUSED,
    GameEngineLayerMode_UIANIM,
    GameEngineLayerMode_GAMEOVER,
    GameEngineLayerMode_RUNOUT
} GameEngineLayerMode;

typedef enum {
	BGMode_NORMAL,
	BGMode_LAB
} BGMode;

@interface GameEngineLayer : CCLayer <GEventListener> {
    NSMutableArray *particles,*particles_tba;
    
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
	
	BGMode cur_bg_mode;
}


@property(readwrite,assign) GameEngineLayerMode current_mode;
@property(readwrite,strong) NSMutableArray *islands, *game_objects;
@property(readwrite,strong) Player *player;
@property(readwrite,assign) CameraZoom camera_state,tar_camera_state;
@property(readwrite,strong) CCFollow *follow_action;

+(CCScene*)scene_with:(NSString *)map_file_name lives:(int)lives;
+(CCScene*)scene_with_autolevel_lives:(int)lives;
+(CCScene*)scene_with_challenge:(ChallengeInfo*)info;

-(ChallengeInfo*)get_challenge;

-(BGMode)get_cur_bg_mode;

-(void)add_particle:(Particle*)p;
-(void)add_gameobject:(GameObject*)o;
-(void)remove_gameobject:(GameObject*)o;

-(HitRect)get_viewbox;
-(HitRect)get_world_bounds;

-(void)set_camera:(CameraZoom)tar;
-(void)set_target_camera:(CameraZoom)tar;

-(int)get_lives;
-(int)get_time;
-(int)get_num_particles;
-(int)get_num_bones;
-(int)get_num_secrets;

-(int)get_current_continue_cost;
-(void)incr_current_continue_cost;

-(void)setColor:(ccColor3B)color;

@end
