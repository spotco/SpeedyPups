#import "UILayer.h"
#import "Player.h"
#import "AutoLevel.h"

@implementation UILayer

+(UILayer*)cons_with_gamelayer:(GameEngineLayer *)g {
    UILayer* u = [UILayer node];
    [GEventDispatcher add_listener:u];
    [u set_gameengine:g];
    [u cons];
    return u;
}

-(void)cons {
    [self cons_ingame_ui];
    [self cons_pause_ui];
    [self cons_gameover_ui];
    [self cons_game_end_menu];
    ingame_ui_anims = [NSMutableArray array];
    self.isTouchEnabled = YES;
    [ingame_ui setVisible:NO];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_GAME_TICK) {
        [ingame_ui setVisible:YES];
        [self update];
        
    } else if (e.type == GEventType_UIANIM_TICK) {
        [ingame_ui setVisible:NO];
        
    } else if (e.type == GEventType_LOAD_LEVELEND_MENU) {
        [self load_game_end_menu];
        
    } else if (e.type == GEventType_COLLECT_BONE) {
        [self start_bone_collect_anim];
        
    } else if (e.type == GEventType_GAMEOVER) {
        [self gameover];
        
    } else if (e.type == GEventType_SHOW_ENEMYAPPROACH_WARNING) {
        enemy_alert_ui_ct = 75;
    
    } else if (e.type == GEventType_START_INTIAL_ANIM) {
        [self start_initial_anim];
    }
}

/* event dispatch handlers */

-(void)update {
    if (enemy_alert_ui_ct > 0) {
        enemy_alert_ui_ct--;
        if (enemy_alert_ui_ct % 10 == 0) {
            [enemy_alert_ui setVisible:!enemy_alert_ui.visible];
        }
    } else {
        [enemy_alert_ui setVisible:NO];
    }
    
    [self set_label:bones_disp to:strf("%i",[game_engine_layer get_num_bones])];
    [self set_label:lives_disp to:strf("\u00B7 %s",[game_engine_layer get_lives] == GAMEENGINE_INF_LIVES ? "\u221E":strf("%i",[game_engine_layer get_lives]).UTF8String)];
    [self set_label:time_disp to:[self parse_gameengine_time:[game_engine_layer get_time]]];
    
    /*if ([GameMain GET_DEBUG_UI]) {
        [self set_label:DEBUG_ctdisp to:strf("isl:%i objs:%i partc:%i",[game_engine_layer.islands count],[game_engine_layer.game_objects count],[game_engine_layer get_num_particles])];
        for (GameObject* o in game_engine_layer.game_objects) {
            if ([o class] == [AutoLevel class]) {
                [self set_label:DEBUG_autolvldisp to:[((AutoLevel*)o) get_debug_msg]];
                break;
            }
        }
    }*/
    
    
    NSMutableArray *toremove = [[NSMutableArray alloc] init];
    for (UIIngameAnimation *i in ingame_ui_anims) {
        [i update];
        if (i.ct <= 0) {
            [self removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [ingame_ui_anims removeObjectsInArray:toremove];
    [toremove removeAllObjects];
}
-(void)start_bone_collect_anim {
    BoneCollectUIAnimation* b = [BoneCollectUIAnimation cons_start:[UILayer player_approx_position:game_engine_layer] end:ccp(0,[[UIScreen mainScreen] bounds].size.width)];
    [self addChild:b];
    [ingame_ui_anims addObject:b];
}
-(void)gameover {
    [ingame_ui setVisible:NO];
    [pause_ui setVisible:NO];
    [self set_label:gameover_bones_disp to:[NSString stringWithFormat:@"Total Bones: %i",[game_engine_layer get_num_bones]]];
    [self set_label:gameover_time_disp to:[NSString stringWithFormat:@"Time: %@",[self parse_gameengine_time:[game_engine_layer get_time]]]];
    [gameover_ui setVisible:YES];
    
}
-(void)load_game_end_menu {
    game_end_menu_layer.isTouchEnabled = NO;
    ingame_ui.visible = NO;
    [[[CCDirector sharedDirector] runningScene] addChild:game_end_menu_layer];
}

/* UI initialzers */

-(void)cons_ingame_ui {
    CCSprite *pauseicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEICON]];
    CCSprite *pauseiconzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEICON]];
    [UILayer set_zoom_pos_align:pauseicon zoomed:pauseiconzoom scale:1.4];
    
    CCMenuItemImage *ingamepause = [CCMenuItemImage itemFromNormalSprite:pauseicon
                                                          selectedSprite:pauseiconzoom
                                                                  target:self 
                                                                selector:@selector(pause)];
    ingamepause.position = ccp([Common SCREEN].width - pauseicon.boundingBox.size.width +20, 
                               [Common SCREEN].height - pauseicon.boundingBox.size.height +20);
    
    CCMenuItem *bone_disp_icon = [self cons_menuitem_tex:[Resource get_tex:TEX_UI_BONE_ICON] pos:ccp([Common SCREEN].width*0.06,[Common SCREEN].height*0.96)];
    CCMenuItem *lives_disp_icon = [self cons_menuitem_tex:[Resource get_tex:TEX_UI_LIVES_ICON] pos:ccp([Common SCREEN].width*0.06,[Common SCREEN].height*0.88)];
    CCMenuItem *time_icon = [self cons_menuitem_tex:[Resource get_tex:TEX_UI_TIME_ICON] pos:ccp([Common SCREEN].width*0.06,[Common SCREEN].height*0.80)];
    
    ccColor3B red = ccc3(255,0,0);
    int fntsz = 15;
    bones_disp = [self cons_label_pos:ccp([Common SCREEN].width*0.03+20,[Common SCREEN].height*0.95) color:red fontsize:fntsz];
    lives_disp = [self cons_label_pos:ccp([Common SCREEN].width*0.03+16,[Common SCREEN].height*0.8725) color:red fontsize:fntsz];
    time_disp = [self cons_label_pos:ccp([Common SCREEN].width*0.03+13,[Common SCREEN].height*0.795) color:red fontsize:fntsz];
    
    enemy_alert_ui = [self cons_menuitem_tex:[Resource get_tex:TEX_UI_ENEMY_ALERT] pos:[Common screen_pctwid:0.9 pcthei:0.5]];
    [enemy_alert_ui setVisible:NO];
    
    ingame_ui = [CCMenu menuWithItems:
                 ingamepause,
                 bone_disp_icon,
                 lives_disp_icon,
                 time_icon,
                 [self label_cons_menuitem:bones_disp leftalign:YES],
                 [self label_cons_menuitem:lives_disp leftalign:YES],
                 [self label_cons_menuitem:time_disp leftalign:YES],
                 enemy_alert_ui,
                 nil];
    
    if ([GameMain GET_DEBUG_UI]) {
        DEBUG_ctdisp = [self cons_label_pos:ccp([Common SCREEN].width*0.02,[Common SCREEN].height*0.71) color:red fontsize:fntsz];
        [ingame_ui addChild:[self label_cons_menuitem:DEBUG_ctdisp leftalign:YES]];
        DEBUG_autolvldisp = [self cons_label_pos:ccp([Common SCREEN].width*0.02,[Common SCREEN].height*0.65) color:red fontsize:fntsz];
        [ingame_ui addChild:[self label_cons_menuitem:DEBUG_autolvldisp leftalign:YES]];
    }
    
    
    
    ingame_ui.anchorPoint = ccp(0,0);
    ingame_ui.position = ccp(0,0);
    [self addChild:ingame_ui];
}
-(void)cons_pause_ui {
    ccColor4B c = {0,0,0,200};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    pause_ui= [CCLayerColor layerWithColor:c width:s.height height:s.width];
    pause_ui.anchorPoint = ccp(0,0);
    
    CCSprite *playimg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_PLAY]];
    CCSprite *playimgzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_PLAY]];
    [UILayer set_zoom_pos_align:playimg zoomed:playimgzoom scale:1.4];
    
    CCMenuItemImage *play = [CCMenuItemImage itemFromNormalSprite:playimg 
                                                   selectedSprite:playimgzoom
                                                           target:self 
                                                         selector:@selector(unpause)];
    play.position = ccp(s.height/2,s.width/2);
    
    CCSprite *backimg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_BACK]];
    CCSprite *backimgzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_BACK]];
    [UILayer set_zoom_pos_align:backimg zoomed:backimgzoom scale:1.4];
    CCMenuItemImage *back = [CCMenuItemImage itemFromNormalSprite:backimg 
                                                   selectedSprite:backimgzoom 
                                                           target:self 
                                                         selector:@selector(exit_to_menu)];
    back.position = ccp(s.height/2-100,s.width/2);
    
    CCMenu* pausemenu = [CCMenu menuWithItems:play,back, nil];
    pausemenu.position = ccp(0,0);
    
    [pause_ui addChild:pausemenu];
    pause_ui.visible = NO;
    [self addChild:pause_ui z:1];
}
-(void)cons_gameover_ui {
    ccColor4B c = {0,0,0,200};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    gameover_ui= [CCLayerColor layerWithColor:c width:s.height height:s.width];
    gameover_ui.anchorPoint = ccp(0,0);
    
    CCSprite *title = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_GAMEOVER_TITLE]];
    [title setPosition:ccp([Common SCREEN].width*0.40,[Common SCREEN].height*0.85)];
    [gameover_ui addChild:title];
    
    CCSprite *logo = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_GAMEOVER_LOGO]];
    [logo setPosition:ccp([Common SCREEN].width*0.80,[Common SCREEN].height*0.85)];
    [gameover_ui addChild:logo];
    
    CCMenuItem *back_to_menu = [Common make_button_tex:[Resource get_tex:TEX_MENU_BUTTON_MENU]
                                                seltex:[Resource get_tex:TEX_MENU_BUTTON_MENU]
                                                zscale:1.2 
                                              callback:[Common cons_callback:self sel:@selector(exit_to_menu)]
                                                   pos:[Common screen_pctwid:0.25 pcthei:0.2]];
    
    CCMenuItem *play_again = [Common make_button_tex:[Resource get_tex:TEX_MENU_BUTTON_PLAYAGAIN]
                                              seltex:[Resource get_tex:TEX_MENU_BUTTON_PLAYAGAIN]
                                              zscale:1.2 
                                            callback:[Common cons_callback:self sel:@selector(play_again)]
                                                 pos:[Common screen_pctwid:0.75 pcthei:0.2]];
    
    ccColor3B white= ccc3(255, 255, 255);
    int fntsz = 25;
    gameover_bones_disp = [self cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.6] color:white fontsize:fntsz];
    [gameover_bones_disp setString:@"Total Bones : 0"];
    
    gameover_time_disp = [self cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.5] color:white fontsize:fntsz];
    [gameover_time_disp setString:@"Time : 0:00"];
    
    
    CCMenu* gameover_menu = [CCMenu menuWithItems:
                             back_to_menu,
                             play_again,
                             [self label_cons_menuitem:gameover_bones_disp leftalign:NO],
                             [self label_cons_menuitem:gameover_time_disp leftalign:NO],
                             nil];
    [gameover_ui addChild:gameover_menu];
    gameover_menu.position = ccp(0,0);
    
    [gameover_ui setVisible:NO];
    [self addChild:gameover_ui z:1];
}
-(void)cons_game_end_menu {
    //TODO -- FIXME
    ccColor4B c = {0,0,0,200};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    game_end_menu_layer= [CCLayerColor layerWithColor:c width:s.height height:s.width];
    game_end_menu_layer.anchorPoint = ccp(0,0);
    
    CCSprite *backimg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_RETURN]];
    CCSprite *backimgzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_PAUSEMENU_RETURN]];
    [UILayer set_zoom_pos_align:backimg zoomed:backimgzoom scale:1.4];
    
    CCMenuItemImage *back = [CCMenuItemImage itemFromNormalSprite:backimg 
                                                   selectedSprite:backimgzoom
                                                           target:self 
                                                         selector:@selector(nextlevel)];
    back.position = ccp(s.height/2,s.width/2);
    
    CCMenu* gameendmenu = [CCMenu menuWithItems:back, nil];
    gameendmenu.position = ccp(0,0);
    
    [game_end_menu_layer addChild:gameendmenu];
}

/* button callbacks */

-(void)pause {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_PAUSE]];
    
    ingame_ui.visible = NO;
    pause_ui.visible = YES;
    [[CCDirector sharedDirector] pause];
}
-(void)unpause {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_UNPAUSE]];
    
    ingame_ui.visible = YES;
    pause_ui.visible = NO;
    [[CCDirector sharedDirector] resume];
}
-(void)exit_to_menu {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_QUIT]];
    [GEventDispatcher dispatch_events];
}
-(void)play_again {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_PLAYAGAIN_AUTOLEVEL]];
}
-(void)nextlevel {
    //TODO -- FIXME
    NSLog(@"nextlevel todoo");
    //[[CCDirector sharedDirector] replaceScene:[GameEngineLayer scene_with:@"cave_test"]];
}

/* UI helpers */

+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale {
    zoomed.scale = scale;
    zoomed.position = ccp((-[zoomed contentSize].width * zoomed.scale + [zoomed contentSize].width)/2
                          ,(-[zoomed contentSize].height * zoomed.scale + [zoomed contentSize].height)/2);
}
-(void)set_gameengine:(GameEngineLayer*)ref {
    game_engine_layer = ref;
}
-(NSString*)parse_gameengine_time:(int)t {
    t*=20;
    return strf("%i:%i%i",t/60000,(t/10000)%6,(t/1000)%10);
}
-(void)set_label:(CCLabelTTF*)l to:(NSString*)s {
    if (![[l string] isEqualToString:s]) {
        [l setString:s];
    }
}
+(CGPoint)player_approx_position:(GameEngineLayer*)game_engine_layer { //inverse of [Common normal_to_gl_coord]
    float outx = game_engine_layer.camera_state.x;
    float outy = game_engine_layer.camera_state.y;
    float outz = game_engine_layer.camera_state.z;
    float playerscrx = (480/2.0)-outx/( (2*(0.907*outz + 237.819)) / (480.0) );
    float playerscry = (320/2.0)-outy/( (2*(0.515*outz + 203.696)) / (320.0) );
    return ccp(playerscrx,playerscry);
}

/* CCMenu shortcut methods */

-(CCLabelTTF*)cons_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize{
    CCLabelTTF *l = [CCLabelTTF labelWithString:@"" fontName:@"Carton Six" fontSize:fontsize];
    [l setColor:color];
    [l setPosition:pos];
    [l setString:@"*"];
    return l;
}
-(CCMenuItemLabel*)label_cons_menuitem:(CCLabelTTF*)l leftalign:(BOOL)leftalign {
    CCMenuItemLabel *m = [CCMenuItemLabel itemWithLabel:l];
    if (leftalign) [m setAnchorPoint:ccp(0,m.anchorPoint.y)];
    return m;
}
-(CCMenuItem*)cons_menuitem_tex:(CCTexture2D*)tex pos:(CGPoint)pos {
    CCMenuItem* i = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithTexture:tex] selectedSprite:[CCSprite spriteWithTexture:tex]];
    [i setPosition:pos];
    return i;
}

/* initial anim handlers */

-(void)start_initial_anim {
    game_engine_layer.current_mode = GameEngineLayerMode_UIANIM;
    ingame_ui.visible = NO;
    curanim = [GameStartAnim cons_with_callback:[Common cons_callback:self sel:@selector(end_initial_anim)]];
    [self addChild:curanim];
}
-(void)end_initial_anim {
    curanim = NULL;
    game_engine_layer.current_mode = GameEngineLayerMode_GAMEPLAY;
    ingame_ui.visible = YES;
    [self removeChild:curanim cleanup:YES];
}

-(void)dealloc {
    [ingame_ui_anims removeAllObjects];
    [game_end_menu_layer removeAllChildrenWithCleanup:YES];
    [pause_ui removeAllChildrenWithCleanup:YES];
    [gameover_ui removeAllChildrenWithCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
}


@end