#import "UILayer.h"
#import "Player.h"
#import "MenuCommon.h"
#import "InventoryItemPane.h"
#import "UserInventory.h"

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
    [self cons_continue_menu];
    [self update_items];
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
        
    } else if (e.type == GEventType_ASK_CONTINUE) {
        [self ask_continue];
        
    } else if (e.type == GEventType_SHOW_ENEMYAPPROACH_WARNING) {
        enemy_alert_ui_ct = 75;
    
    } else if (e.type == GEventType_START_INTIAL_ANIM) {
        [self start_initial_anim];
        
    } else if (e.type == GEventType_ITEM_DURATION_PCT) {
        item_duration_pct = e.f1;
        
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
-(void)ask_continue {
    [ingame_ui setVisible:NO];
    [pause_ui setVisible:NO];
    [ask_continue_ui setVisible:YES];
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
    [ingamepause setPosition:[Common screen_pctwid:0.95 pcthei:0.9]];
    
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
    
    ingame_ui_item_slot = [MainSlotItemPane cons_pt:[Common screen_pctwid:0.93 pcthei:0.09] cb:[Common cons_callback:self sel:@selector(itemslot_use)] slot:0];
    [ingame_ui_item_slot setScale:0.75];
    [ingame_ui_item_slot setOpacity:120];
    
    ingame_ui = [CCMenu menuWithItems:
                 ingamepause,
                 bone_disp_icon,
                 lives_disp_icon,
                 time_icon,
                 [self label_cons_menuitem:bones_disp leftalign:YES],
                 [self label_cons_menuitem:lives_disp leftalign:YES],
                 [self label_cons_menuitem:time_disp leftalign:YES],
                 enemy_alert_ui,
                 ingame_ui_item_slot,
                 nil];
    
    ingame_ui.anchorPoint = ccp(0,0);
    ingame_ui.position = ccp(0,0);
    [self addChild:ingame_ui];
}

-(void)update_items {
    [ingame_ui_item_slot set_item:[UserInventory get_item_at_slot:0] ct:1];
    for (SlotItemPane *i in pause_menu_item_slots) {
        if ([i get_slot] <= [UserInventory get_num_slots_unlocked]) {
            [i set_item:[UserInventory get_item_at_slot:[i get_slot]] ct:1];
        } else {
            [i set_locked:YES];
        }
    }
}

-(void)update_pausemenu_info {
    [pause_lives_disp setString:[lives_disp string]];
    [pause_bones_disp setString:[bones_disp string]];
    [pause_time_disp setString:[time_disp string]];
}

-(void)itemslot_use {
    if ([UserInventory get_item_at_slot:0] != Item_NOITEM) {
        GameItem i = [UserInventory get_item_at_slot:0];
        [UserInventory set_item:Item_NOITEM to_slot:0];
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_USE_ITEM] add_i1:i i2:0]];
        
        [GameItemCommon queue_item];
        
        [self update_items];
    }
}

-(void)retry {
    //TODO: work
    NSLog(@"retry");
}

-(void)cons_pause_ui {
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    pause_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    pause_ui.anchorPoint = ccp(0,0);
    [pause_ui setPosition:ccp(0,0)];
    
    [pause_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
    
    CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [timebg setPosition:[Common screen_pctwid:0.75 pcthei:0.6]];
    [pause_ui addChild:timebg];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [bonesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.45]];
    [pause_ui addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.3]];
    [pause_ui addChild:livesbg];
    
    pause_time_disp = [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.6]
                                               color:ccc3(255, 255, 255)
                                            fontsize:30
                                                 str:@"0:00"];
    [pause_ui addChild:pause_time_disp];
    
    pause_bones_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.45]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_bones_disp];
    
    pause_lives_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.3]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_lives_disp];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.5 pcthei:0.6]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.35 pcthei:0.6]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"backbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.20 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [pause_ui addChild:pausebuttons];
    
    NSMutableArray* tslots = [NSMutableArray array];
    MainSlotItemPane *mainslot = [MainSlotItemPane cons_pt:ccp(-50,-15) cb:[Common cons_callback:self sel:@selector(slotpane0_click)] slot:0];
    CCMenu *slotitems = [CCMenu menuWithItems:nil];
    [tslots addObject:mainslot];
    [slotitems addChild:mainslot];
    
    float panewid = [SlotItemPane invpane_size].size.width;
    float panehei = [SlotItemPane invpane_size].size.height;
    SEL slotsel[] = {@selector(slotpane0_click),@selector(slotpane1_click),@selector(slotpane2_click),@selector(slotpane3_click),@selector(slotpane4_click),@selector(slotpane5_click),@selector(slotpane6_click)};
    for(int i = 0; i < 6; i++) {
        SlotItemPane *slp = [SlotItemPane cons_pt:ccp((panewid+12)*(i%3),-(panehei+12)*(i/3)) cb:[Common cons_callback:self sel:slotsel[i+1]] slot:i+1];
        [slotitems addChild:slp];
        [tslots addObject:slp];
    }
    [slotitems setPosition:[Common screen_pctwid:0.35 pcthei:0.4]];
    [pause_ui addChild:slotitems];
    pause_menu_item_slots = tslots;
    
    [pause_ui setVisible:NO];
    [self addChild:pause_ui z:1];
}

-(void)slotpane0_click {[self slotpane_click:0];}
-(void)slotpane1_click {[self slotpane_click:1];}
-(void)slotpane2_click {[self slotpane_click:2];}
-(void)slotpane3_click {[self slotpane_click:3];}
-(void)slotpane4_click {[self slotpane_click:4];}
-(void)slotpane5_click {[self slotpane_click:5];}
-(void)slotpane6_click {[self slotpane_click:6];}

-(void)slotpane_click:(int)i {
    if (i > 0 && i <= [UserInventory get_num_slots_unlocked]) {
        GameItem s0 = [UserInventory get_item_at_slot:0];
        GameItem si = [UserInventory get_item_at_slot:i];
        [UserInventory set_item:si to_slot:0];
        [UserInventory set_item:s0 to_slot:i];
    }
    [self update_items];
}

-(void)cons_continue_menu {
    ccColor4B c = {0,0,0,200};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    ask_continue_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]]
                                                      rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.4]]];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spotlight"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.6]]];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.8]]];
    
    CCMenuItem *yes = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                       rect:@"yesbutton"
                                        tar:self sel:@selector(continue_yes)
                                        pos:[Common screen_pctwid:0.3 pcthei:0.4]];
    
    CCMenuItem *no = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                       rect:@"nobutton"
                                        tar:self sel:@selector(continue_no)
                                        pos:[Common screen_pctwid:0.7 pcthei:0.4]];
    
    CCMenu *m = [CCMenu menuWithItems:yes,no, nil];
    [m setPosition:CGPointZero];
    [ask_continue_ui addChild:m];
    
    [self addChild:ask_continue_ui];
    [ask_continue_ui setVisible:YES];
}

-(void)continue_no {
    
}

-(void)continue_yes {
    
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
    [self update_pausemenu_info];
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

-(void)draw {
    [super draw];
    [self draw_item_duration_line];
}

-(void)draw_item_duration_line {
    glColor4ub(255,0,0,100);
    glLineWidth(10.0f);
    CGPoint a = [Common screen_pctwid:0.885 pcthei:0.18];
    CGPoint b = [Common screen_pctwid:0.975 pcthei:0.18];
    CGPoint dab = ccp(b.x-a.x,b.y-a.y);
    dab.x *= item_duration_pct;
    ccDrawLine(a,ccp(a.x+dab.x,a.y+dab.y));
}


@end