#import "GameEngineLayer.h"
#import "BGLayer.h"
#import "UILayer.h"
#import "FlashEffect.h"
#import "TouchTrackingLayer.h"
#import "GameItemCommon.h"
#import "UserInventory.h"
#import "OneUpParticle.h"
#import "GameModeCallback.h"
#import "BGTimeManager.h"

@implementation GameEngineLayer

#define tLOADSCR 1
#define tBGLAYER 2
#define tGLAYER 3
#define tFGLAYER 4
#define tUILAYER 5
#define tTTRACKLAYER 6

#define DEFAULT_CONTINUE_COST 100

@synthesize current_mode;
@synthesize game_objects,islands;
@synthesize player;
@synthesize camera_state,tar_camera_state;

+(CCScene *) scene_with:(NSString *)map_file_name lives:(int)lives {
    CCScene *scene = [CCScene node];
    GameEngineLayer *glayer = [GameEngineLayer layer_from_file:map_file_name lives:lives];
	BGLayer *bglayer = [BGLayer cons_with_gamelayer:glayer];
    UILayer* uilayer = [UILayer cons_with_gamelayer:glayer];
    
    [scene addChild:[CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)]];
    [scene addChild:bglayer z:0 tag:tBGLAYER];
    [scene addChild:glayer z:0 tag:tGLAYER];
    [scene addChild:uilayer z:0 tag:tUILAYER];
    [scene addChild:[TouchTrackingLayer node] z:0 tag:tTTRACKLAYER];
    
    [scene addChild:[Common get_load_scr] z:1 tag:tLOADSCR];
	return scene;
}
+(CCScene*) scene_with_autolevel_lives:(int)lives {
    CCScene* scene = [GameEngineLayer scene_with:@"connector" lives:lives];
    GameEngineLayer* glayer = (GameEngineLayer*)[scene getChildByTag:tGLAYER];
    AutoLevel* nobj = [AutoLevel cons_with_glayer:glayer];
    [glayer.game_objects addObject:nobj];
    [glayer addChild:nobj];
    
    UILayer* uil = (UILayer*)[scene getChildByTag:tUILAYER];
    [uil set_retry_callback:[GameModeCallback cons_mode:GameMode_FREERUN n:0]];
    
    [nobj update:glayer.player g:glayer]; //have first section preloaded
    [glayer update_render];
    
    [glayer move_player_toground];
    [glayer prep_runin_anim];
	[uil start_freeruninfocard_anim];
	return scene;
}

+(CCScene*)scene_with_challenge:(ChallengeInfo*)info {
	[MapLoader set_maploader_mode:MapLoaderMode_CHALLENGE];
    CCScene* scene = [GameEngineLayer scene_with:info.map_name lives:GAMEENGINE_INF_LIVES];
	[MapLoader set_maploader_mode:MapLoaderMode_AUTO];
    GameEngineLayer* glayer = (GameEngineLayer*)[scene getChildByTag:tGLAYER];
    
    UILayer* uil = (UILayer*)[scene getChildByTag:tUILAYER];
    [uil set_retry_callback:[GameModeCallback cons_mode:GameMode_CHALLENGE n:[ChallengeRecord get_number_for_challenge:info]]];
    
	[glayer set_challenge:info];
	[glayer update_render];
    [glayer move_player_toground];
    [glayer prep_runin_anim];
	
	[uil start_challengeinfocard_anim];
	
    return scene;
}

+(GameEngineLayer*)layer_from_file:(NSString*)file lives:(int)lives {
    GameEngineLayer *g = [GameEngineLayer node];
    [g cons:file lives:lives];
    return g;
}

-(void)cons:(NSString*)map_filename lives:(int)starting_lives {
    if (particles_tba == NULL) {
        particles_tba = [[NSMutableArray alloc] init];
    }
    default_starting_lives = starting_lives;
	
    [AudioManager playbgm_imm:BGM_GROUP_WORLD1];
	if ([BGTimeManager get_global_time] == MODE_NIGHT || [BGTimeManager get_global_time] == MODE_DAY_TO_NIGHT) {
		[AudioManager transition_mode2];
	}
    
    [GameControlImplementation reset_control_state];
    [GEventDispatcher add_listener:self];
    refresh_viewbox_cache = YES;
    CGPoint player_start_pt = [self loadMap:map_filename];
    particles = [[NSMutableArray alloc] init];
    player = [Player cons_at:player_start_pt];
	[self follow_player];
    [self addChild:player z:[GameRenderImplementation GET_RENDER_PLAYER_ORD]];
    
    DogShadow *d = [DogShadow cons];
    [self.game_objects addObject:d];
    [self addChild:d z:[d get_render_ord]];
    
    
    self.isTouchEnabled = YES;
    
    
    int draw_ctx_z[] =  {
        [GameRenderImplementation GET_RENDER_BTWN_PLAYER_ISLAND],
        [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD],
        [GameRenderImplementation GET_RENDER_GAMEOBJ_ORD],
        [GameRenderImplementation GET_RENDER_ISLAND_ORD]
    };
    for (int i = 0; i < arrlen(draw_ctx_z); i++) {
        [self addChild:[BatchDraw node] z:draw_ctx_z[i]];
    }
    
    [self reset_camera];
    
    lives = starting_lives;
    
    [self update_render];
    [self schedule:@selector(update:)];
	
    scrollup_pct = 1;
    current_mode = GameEngineLayerMode_SCROLLDOWN;
    float tmp;
    [camera_ centerX:&tmp centerY:&defcey centerZ:&tmp];
    current_continue_cost = DEFAULT_CONTINUE_COST;
    player_starting_pos = player_start_pt;
}

-(void)set_challenge:(ChallengeInfo*)info {
    //NSLog(@"loaded challenge for %@, %@",info.map_name,[info to_string]);
    [GEventDispatcher immediate_event:[[GEvent cons_type:GEventType_CHALLENGE] add_key:@"challenge" value:info]];
	//[GEventDispatcher dispatch_events];
    for (GameObject *o in game_objects) {
        [o notify_challenge_mode:info];
    }
    challenge = info;
}

-(ChallengeInfo*)get_challenge {
	return challenge;
}

-(void)move_player_toground {
    CGPoint pos = player.position;
    for (Island* i in islands) {
        if (pos.x > i.endX || pos.x < i.startX) continue;
        float ipos = [i get_height:pos.x];
        if (ipos != [Island NO_VALUE] && pos.y > ipos && (pos.y - ipos)) {
            player.position = ccp(player.position.x,ipos);
            player.current_island = i;
            player_starting_pos = player.position;
            return;
        }
    }
}

-(void)prep_runin_anim { //need 1 tick of update to adjust camera
    [player setVisible:NO];
    do_runin_anim = YES;
}

-(void)update_render {
    [BatchDraw clear];
    for (GameObject *o in game_objects) {
        [o check_should_render:self];
    }
    for (Island *i in islands) {
        [i check_should_render:self];
    }
    [BatchDraw sort_jobs];
}

-(CGPoint)loadMap:(NSString*)filename {
	GameMap *map = [MapLoader load_map:filename];
    
    islands = map.n_islands;
    int ct = [Island link_islands:islands];
    if (ct != map.assert_links) {
        NSLog(@"ERROR: expected %i links, got %i.",map.assert_links,ct);
    }
    
    for (Island* i in islands) {
        [self addChild:i z:[i get_render_ord]];
	}
    
    game_objects = map.game_objects;
    for (GameObject* o in game_objects) {
        [self addChild:o z:[o get_render_ord]];
    }
    
    World1ParticleGenerator *w1 = [World1ParticleGenerator cons];
    [game_objects addObject:w1];
    [self addChild:w1];
    
    return map.player_start_pt;
}

-(void)player_reset {
    if (challenge != NULL) {
        collected_bones = 0;
        time = 0;
        collected_secrets = 0;
    }
    for (int i = 0; i < game_objects.count; i++) {
        GameObject *o = [game_objects objectAtIndex:i];
        [o reset];
    }
    
    [player reset];
    [self reset_camera];
    [GameControlImplementation reset_control_state];
	[self follow_player];
    current_mode = GameEngineLayerMode_GAMEPLAY;
}

-(void)check_falloff {
    if (![Common hitrect_touch:[self get_world_bounds] b:[player get_hit_rect]]) {
        [GEventDispatcher push_unique_event:[GEvent cons_type:GEventType_PLAYER_DIE]];
	}
}

-(void)frame_set_follow_clamp_y_min:(float)min max:(float)max {
	follow_clamp_y_max = -min;
	follow_clamp_y_min = -(max - [[CCDirector sharedDirector] winSize].height);
}

-(void)reset_follow_clamp_y {
	follow_clamp_y_min = -INFINITY;
	follow_clamp_y_max = INFINITY;
}

-(void)follow_player {
	CGSize s = [[CCDirector sharedDirector] winSize];
	CGPoint halfScreenSize = ccp(s.width/2,s.height/2);
	[self setPosition:ccp(
		clampf(halfScreenSize.x-player.position.x,-INFINITY,INFINITY),
		clampf(halfScreenSize.y-player.position.y,follow_clamp_y_min,follow_clamp_y_max)
	)];
}

-(void)update:(ccTime)delta {
	[Common set_dt:delta];
	[self reset_follow_clamp_y];
    [[[[CCDirector sharedDirector] runningScene] getChildByTag:tLOADSCR] setVisible:NO];
	
	if (player.is_clockeffect && current_mode == GameEngineLayerMode_GAMEPLAY) {
		[CCDirectorDisplayLink set_framemodct:2];
	} else {
		[CCDirectorDisplayLink set_framemodct:1];
	}
	
    [GEventDispatcher dispatch_events];
    if (current_mode == GameEngineLayerMode_GAMEPLAY) {
        time+=[Common get_dt_Scale];
		
		refresh_viewbox_cache = YES;
		[GameControlImplementation control_update_player:self];
		[GamePhysicsImplementation player_move:player with_islands:islands];
		
		[player update:self];
		[self check_falloff];
		
		[self update_gameobjs];
		[self update_particles];
		[self push_added_particles];
		[self update_render];
		[GameRenderImplementation update_render_on:self];
		[GEventDispatcher push_event:[GEvent cons_type:GEventType_GAME_TICK]];
		[self follow_player];
        
    } else if (current_mode == GameEngineLayerMode_UIANIM) {
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_UIANIM_TICK]];
		[self follow_player];
        
    } else if (current_mode == GameEngineLayerMode_SCROLLDOWN) {
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_GAME_TICK]];
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_UIANIM_TICK]];
        scrollup_pct-=0.02*[Common get_dt_Scale];
        if (scrollup_pct <= 0) {
            scrollup_pct = 0;
            if (do_runin_anim) {
                current_mode = GameEngineLayerMode_CAMERAFOLLOWTICK;
            } else {
                current_mode = GameEngineLayerMode_GAMEPLAY;
            }
        }
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_SCROLLBGUP_PCT] add_f1:scrollup_pct f2:0]];
        float ex,ey,ez,cx,cy,cz;
        [camera_ eyeX:&ex eyeY:&ey eyeZ:&ez];
        [camera_ centerX:&cx centerY:&cy centerZ:&cz];
        
        [camera_ setEyeX:ex eyeY:defcey+1000*scrollup_pct eyeZ:ez];
        [camera_ setCenterX:cx centerY:defcey+1000*scrollup_pct centerZ:cz];
		[self follow_player];
        
    } else if (current_mode == GameEngineLayerMode_CAMERAFOLLOWTICK) {
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_UIANIM_TICK]];
        current_mode = GameEngineLayerMode_RUNINANIM;
		[self follow_player];
        [player setPosition:CGPointAdd(player.position, ccp(-300,0))];
        [player setVisible:YES];
        [player do_run_anim];
    
    } else if (current_mode == GameEngineLayerMode_RUNINANIM) {
        for (GameObject *i in game_objects) if ([i class] == [DogShadow class]) [i update:player g:self];
        [self update_particles];
        [self push_added_particles];
        if (player.position.x < player_starting_pos.x) {
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_UIANIM_TICK]];
            [player setPosition:ccp(player.position.x+10*[Common get_dt_Scale],player_starting_pos.y)];
        } else {
            player.position = ccp(player_starting_pos.x,player.position.y);
            [player do_stand_anim];
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_START_INTIAL_ANIM]];
        }
        
    } else if (current_mode == GameEngineLayerMode_RUNOUT) {
        runout_ct--;
        if (runout_ct <= 0) {
            current_mode = GameEngineLayerMode_GAMEOVER;
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_LOAD_CHALLENGE_COMPLETE_MENU]];
        } else {        
            [GamePhysicsImplementation player_move:player with_islands:islands];
            [player update:self];
            [self update_gameobjs];
            [self update_particles];
            [self push_added_particles];
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_UIANIM_TICK]];
        }
    }
    
    [GEventDispatcher dispatch_events];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_QUIT) {
        [self exit];
        [GameMain start_menu];
        
    } else if (e.type == GEventType_RETRY_WITH_CALLBACK) {
        [self exit];
        GameModeCallback *cb = [e get_value:@"callback"];
        [cb run];
    
    } else if (e.type == GEventType_PLAYAGAIN_AUTOLEVEL) {
        [self exit];
        [GameMain start_game_autolevel];
        
    } else if (e.type == GEventType_CHECKPOINT) {
        [self set_checkpoint_to:e.pt];
        
    } else if (e.type == GEventType_COLLECT_BONE) {
        collected_bones++;
        if (challenge == NULL && collected_bones%100==0) {
            [self add_particle:[OneUpParticle cons_pt:[player get_center]]];
            [self incr_lives];
        }
        [UserInventory add_bones:1];
        
    } else if (e.type == GEventType_GET_COIN) {
        if (collected_bones%100 > (collected_bones+10)%100) {
            [self add_particle:[OneUpParticle cons_pt:[player get_center]]];
            [self incr_lives];
        }
        collected_secrets++;
        collected_bones+=10;
        [UserInventory add_bones:10];
    
    } else if (e.type == GEventType_CHALLENGE_COMPLETE) {
        runout_ct = 100;
        current_mode = GameEngineLayerMode_RUNOUT;
        
    } else if (e.type == GEventType_PAUSE) {
        current_mode = GameEngineLayerMode_PAUSED;
        
    } else if (e.type == GEventType_UNPAUSE) {
        current_mode = GameEngineLayerMode_GAMEPLAY;
        
    } else if (e.type == GEventType_PLAYER_DIE) {
        if (![player has_heart]) {
            lives = lives == GAMEENGINE_INF_LIVES ? lives : lives-1;
        }
        if (lives != GAMEENGINE_INF_LIVES && lives < 1) {
            [self ask_continue];
        } else {
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_GAME_RESET]];
            [self player_reset];
            [player add_effect:[FlashEffect cons_from:[player get_current_params] time:35]];
        }
        
    } else if (e.type == GEventType_USE_ITEM) {
        [GameItemCommon use_item:e.i1 on:self];
        
    } else if (e.type == GEventType_CONTINUE_GAME) {
        lives = default_starting_lives;
        [GEventDispatcher push_event:[GEvent cons_type:GEventType_GAME_RESET]];
        [self player_reset];
        [player add_effect:[FlashEffect cons_from:[player get_current_params] time:35]];
        
    } else if (e.type == GEventType_ENTER_LABAREA) {
		cur_bg_mode = BGMode_LAB;
		
	} else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
		cur_bg_mode = BGMode_NORMAL;
		
	}
}

-(BGMode)get_cur_bg_mode {
	return cur_bg_mode;
}

-(void)update_gameobjs {
    for(int i = [game_objects count]-1; i>=0 ; i--) {
        GameObject *o = [game_objects objectAtIndex:i];
        [o update:player g:self];
    }
}

-(void)add_gameobject:(GameObject*)o {
    [game_objects addObject:o];
    [self addChild:o z:[o get_render_ord]];
}
-(void)remove_gameobject:(GameObject *)o {
    [game_objects removeObject:o];
    [self removeChild:o cleanup:YES];
}

/* event dispatch handlers */

-(void)ask_continue {
    current_mode = GameEngineLayerMode_GAMEOVER;
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_ASK_CONTINUE]];
}
-(void)exit {
    [self unscheduleAllSelectors];
    //[self set_records];
    
    [GEventDispatcher remove_all_listeners];
    [[CCDirector sharedDirector] resume];
    [BatchDraw clear];
}

/* camera interface */

-(void)reset_camera {
    [GameRenderImplementation reset_camera:&camera_state];
    [GameRenderImplementation reset_camera:&tar_camera_state];
    [GameRenderImplementation update_camera_on:self zoom:camera_state];
}
-(void)set_target_camera:(CameraZoom)tar {
    tar_camera_state = tar;
}
-(void)set_camera:(CameraZoom)tar {
    camera_state = tar;
}

/* bone system */
-(void)set_checkpoint_to:(CGPoint)pt {
    player.start_pt = pt;
}

/* helpers */
-(void)addChild:(CCNode *)node z:(NSInteger)z {
    refresh_worldbounds_cache = YES;
    [super addChild:node z:z];
}
-(void)setColor:(ccColor3B)color {
	for(CCSprite *sprite in islands) {
        [sprite setColor:color];
	}
    for(CCSprite *sprite in game_objects) {
        [sprite setColor:color];
    }
    [player setColor:color];
}

/* getters */

-(HitRect) get_world_bounds {
    if (refresh_worldbounds_cache) {
        refresh_worldbounds_cache = NO;
        float min_x = 5000;
        float min_y = 5000;
        float max_x = -5000;
        float max_y = -5000;
        for (Island* i in islands) {
            max_x = MAX(MAX(max_x, i.endX),i.startX);
            max_y = MAX(MAX(max_y, i.endY),i.startY);
            min_x = MIN(MIN(min_x, i.endX),i.startX);
            min_y = MIN(MIN(min_y, i.endY),i.startY);
        }
        for(GameObject* o in game_objects) {
            max_x =MAX(max_x, o.position.x);
            max_y = MAX(max_y, o.position.y);
            min_x = MIN(min_x, o.position.x);
            min_y =MIN(min_y, o.position.y);
        }
        HitRect r = [Common hitrect_cons_x1:min_x y1:min_y-200 x2:max_x+1000 y2:max_y+2000];
        cached_worldsbounds = r;
    }
    return cached_worldsbounds;
}
-(HitRect)get_viewbox {
    if (current_mode == GameEngineLayerMode_SCROLLDOWN || current_mode == GameEngineLayerMode_RUNINANIM) {
        return [Common hitrect_cons_x1:player.position.x-1500 y1:player.position.y-1500 wid:4000 hei:3000];
    }
    
    if (refresh_viewbox_cache) {
        refresh_viewbox_cache = NO;
        cached_viewbox = [Common hitrect_cons_x1:-self.position.x-[Common SCREEN].width*1
                                              y1:-self.position.y-[Common SCREEN].height*1
                                             wid:[Common SCREEN].width*4
                                             hei:[Common SCREEN].height*4];
    }
    return cached_viewbox;
}
-(int)get_lives { return lives; }
-(int)get_time { return time; }
-(int)get_num_bones { return collected_bones; }
-(int)get_num_secrets { return collected_secrets; }

-(int)get_current_continue_cost {return current_continue_cost;}
-(void)incr_current_continue_cost {current_continue_cost*=2;}


/* particle system */
-(void)add_particle:(Particle*)p {
    [particles_tba addObject:p];
}
-(int)get_num_particles {
    return [particles count];
}
-(void)push_added_particles {
    for (Particle *p in particles_tba) {
        [particles addObject:p];
        [self addChild:p z:[p get_render_ord]];
    }
    [particles_tba removeAllObjects];
}
-(void)update_particles {
    NSMutableArray *toremove = [NSMutableArray array];
    for (Particle *i in particles) {
        [i update:self];
        if ([i should_remove]) {
            [self removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [particles removeObjectsInArray:toremove];
}

-(void) ccTouchesBegan:(NSSet*)pTouches withEvent:(UIEvent*)pEvent {
    if (current_mode != GameEngineLayerMode_GAMEPLAY) {
        return;
    }
    
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
    [GameControlImplementation touch_begin:touch];
}
-(void) ccTouchesMoved:(NSSet *)pTouches withEvent:(UIEvent *)event {
    if (current_mode != GameEngineLayerMode_GAMEPLAY) {
        return;
    }
    
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
    [GameControlImplementation touch_move:touch];
}
-(void) ccTouchesEnded:(NSSet*)pTouches withEvent:(UIEvent*)event {
    if (current_mode != GameEngineLayerMode_GAMEPLAY) {
        return;
    }
    
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
    [GameControlImplementation touch_end:touch];
}

-(void)draw {
    [super draw];
    
    if (![GameMain GET_DRAW_HITBOX]) {
        return;
    }
    glColor4ub(255,0,0,100);
    glLineWidth(1.0f);
    HitRect re = [player get_hit_rect]; 
    CGPoint *verts = [Common hitrect_get_pts:re];
    ccDrawPoly(verts, 4, YES);
    
    if (player.current_island == NULL) {
        CGPoint a = ccp(verts[2].x,verts[2].y);
        Vec3D dv = [VecLib cons_x:player.vx y:player.vy z:0];
        [VecLib normalize:dv];
        [VecLib scale:dv by:50];
        CGPoint b = ccp(a.x+dv.x,a.y+dv.y);
        ccDrawLine(a, b);
    }
    free(verts);
    
    for (GameObject* o in game_objects) {
        HitRect pathBox = [o get_hit_rect];
        verts = [Common hitrect_get_pts:pathBox];
        ccDrawPoly(verts, 4, YES);
        free(verts);
    }
    
    HitRect viewbox = [self get_viewbox];
    verts = [Common hitrect_get_pts:viewbox];
    ccDrawPoly(verts, 4, YES);
    free(verts);
 }

-(void)incr_lives {
	lives = lives == GAMEENGINE_INF_LIVES ? lives : lives+1;
}

-(void)dealloc {
    [self removeAllChildrenWithCleanup:YES];
    [islands removeAllObjects];
    [game_objects removeAllObjects];
    [particles removeAllObjects];
}


@end
