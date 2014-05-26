#import "NMenuPlayPage.h"
#import "MenuCommon.h"
#import "Flowers.h"
#import "GameMain.h"
#import "FreeRunStartAtManager.h"
#import "ScoreManager.h"
#import "UserInventory.h"
#import "InventoryTabPane_Prizes.h"

@implementation NMenuPlayPage

+(NMenuPlayPage*)cons {
    return [NMenuPlayPage node];
}

#define tDHMASK 1
#define tFLOWER 2

-(id)init {
    self = [super init];
    [GEventDispatcher add_listener:self];
    cur_mode = PlayPageMode_WAIT;
	
	[self cons_highscore_sign];
    
	logo_base = [CCSprite node];
	[logo_base setPosition:[Common screen_pctwid:0.5 pcthei:0.75]];
	[self addChild:logo_base];
	
	CCSprite *logo_bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
										  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"logo_flyin_base"]];
	[logo_base addChild:logo_bg];
	
	CCSprite *logo_circle = [CCSprite node];
	logo = logo_circle;
	[logo_circle setPosition:ccp(25,25)];
	id reptrig = [CCCallFunc actionWithTarget:self selector:@selector(repeatbounce)];
    [logo runAction:[CCSequence actions:[self cons_logojump_anim],reptrig, nil]];
	[logo_base addChild:logo_circle];
	
	CCSprite *logo_pups = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
											 rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"logo_flyin_pups"]];
	[logo_base addChild:logo_pups];
	
	CCSprite *logo_speedy = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
											   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"logo_flyin_speedy"]];
	[logo_base addChild:logo_speedy];
    
    playbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_runbutton"
                                               tar:self sel:@selector(run_button_pressed)
                                               pos:[Common screen_pctwid:0.5 pcthei:0.34]];
    
    nav_menu = [MenuCommon cons_common_nav_menu];
    [self addChild:nav_menu z:5];
    
    [self addChild:[Flowers cons_pt:[Common screen_pctwid:0.275 pcthei:0.35]] z:0 tag:tFLOWER];
    
    birds = [BirdFlock cons_x:[Common SCREEN].width*0.8 y:[Common SCREEN].height*0.25];
    [birds setScale:0.75];
    [self addChild:birds];
    
    CCMenu *m = [CCMenu menuWithItems:playbutton, nil];
    [m setPosition:ccp(0,0)];
	[self cons_wheel_button:m];
    [self addChild:m];
    
    rundog = [CCSprite node];
	
	
    
    CCMenuItem *freerunmodebutton = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
													 rect:@"infinitemode"
													  tar:self
													  sel:@selector(freerun_button_pressed)
													  pos:[Common screen_pctwid:0.35 pcthei:0.35]];
	[[((CCMenuItemSprite*)freerunmodebutton) normalImage] addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Free Run"]];
	[[((CCMenuItemSprite*)freerunmodebutton) selectedImage] addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Free Run"]];
    
	CCMenuItem *challengemodebutton = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
													   rect:@"challengemodebutton"
														tar:self
														sel:@selector(challengemode_button_button_pressed)
														pos:[Common screen_pctwid:0.65 pcthei:0.35]];
    [[((CCMenuItemSprite*)challengemodebutton) normalImage] addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Challenge"]];
    [[((CCMenuItemSprite*)challengemodebutton) selectedImage] addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Challenge"]];
	
	
	
	CCMenuItemSprite *startworlddisp = (CCMenuItemSprite*)[MenuCommon item_from:TEX_NMENU_ITEMS
														rect:@"playpage_infoside"
														 tar:self
														 sel:@selector(startworlddispbutton_pressed)
														 pos:CGPointZero];
	[startworlddisp setAnchorPoint:ccp(1,0.5)];
	[startworlddisp setPosition:ccp(
		freerunmodebutton.position.x - freerunmodebutton.boundingBox.size.width/2.0f + 10,
		freerunmodebutton.position.y
	)];
	
	#define TOPLEFTLABEL(x) [[Common cons_label_pos:[Common pct_of_obj:startworlddisp pctx:0.085 pcty:0.93] color:ccc3(200,30,30) fontsize:9 str:x] anchor_pt:ccp(0,1)]
	[startworlddisp.normalImage addChild:TOPLEFTLABEL(@"starting at:")];
	[startworlddisp.selectedImage addChild:TOPLEFTLABEL(@"starting at")];
	
	#define TOPRIGHTLABEL(x) [[Common cons_label_pos:[Common pct_of_obj:startworlddisp pctx:0.5 pcty:0.78] color:ccc3(0,0,0) fontsize:12 str:x] anchor_pt:ccp(0.5,1)]
	CCLabelTTF *startworlddisp_a = TOPRIGHTLABEL(@"");
	CCLabelTTF *startworlddisp_b = TOPRIGHTLABEL(@"");
	[startworlddisp.normalImage addChild:startworlddisp_a];
	[startworlddisp.selectedImage addChild:startworlddisp_b];
	startworld_disp = [[[[LabelGroup alloc] init] add_label:startworlddisp_a] add_label:startworlddisp_b];
	[startworld_disp set_string:@""];
	
	#define SPRITEICON(x) [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"icon_tutorial"]] pos:[Common pct_of_obj:startworlddisp pctx:0.5 pcty:0.33]]
	CCSprite *swdispicon_a = SPRITEICON(@"icon_tutorial");
	CCSprite *swdispicon_b = SPRITEICON(@"icon_tutorial");
	[swdispicon_a setScale:0.7];
	[swdispicon_b setScale:0.7];
	startworld_disp_icon = [[[[SpriteGroup alloc] init] add_sprite:swdispicon_a] add_sprite:swdispicon_b];
	[startworlddisp.normalImage addChild:swdispicon_a];
	[startworlddisp.selectedImage addChild:swdispicon_b];
	
	
	CCSprite *challengescompleteddisp = [CCSprite node];
	CCSprite *chcodis_body = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"playpage_infoside"]];
	[chcodis_body setScaleX:-1];
	[challengescompleteddisp addChild:chcodis_body];
	[chcodis_body setPosition:[Common pct_of_obj:chcodis_body pctx:0.5 pcty:0]];
	[challengescompleteddisp setPosition:ccp(challengemodebutton.position.x + challengemodebutton.boundingBox.size.width/2.0 - 10,challengemodebutton.position.y)];
	[challengescompleteddisp addChild:[[Common cons_label_pos:[Common pct_of_obj:chcodis_body pctx:0.9 pcty:0.93-0.5]
														color:ccc3(200,30,30)
													 fontsize:9 str:@"Completed:"] anchor_pt:ccp(1,1)]];
	challenges_completed_disp = [Common cons_label_pos:[Common pct_of_obj:chcodis_body pctx:0.55 pcty:0.5-0.5]
												 color:ccc3(0,0,0)
											  fontsize:20
												   str:@"00/00"];
	[challengescompleteddisp addChild:challenges_completed_disp];
	
	CCMenuItemImage *challengecompletedisp_wrapper = [CCMenuItemImage itemWithTarget:self selector:@selector(null_selector)];
	[challengecompletedisp_wrapper addChild:challengescompleteddisp];
	
    mode_choose_menu = [CCMenu menuWithItems:startworlddisp,challengecompletedisp_wrapper,freerunmodebutton,challengemodebutton,nil];
    [mode_choose_menu setPosition:ccp(0,0)];
    [self addChild:mode_choose_menu];
    [mode_choose_menu setVisible:NO];
    
    challengeselect = [ChallengeModeSelect cons];
    [challengeselect setVisible:NO];
    [self addChild:challengeselect];
	
	first_time_popup = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"first_time_popup"]];
	[first_time_popup setAnchorPoint:ccp(1,0)];
	[first_time_popup addChild:[Common cons_bmlabel_pos:[Common pct_of_obj:first_time_popup pctx:0.5 pcty:0.8]
												color:ccc3(10,10,10)
											 fontsize:11
												  str:@"First time?"]];
	[first_time_popup addChild:[Common cons_bmlabel_pos:[Common pct_of_obj:first_time_popup pctx:0.5 pcty:0.5]
												color:ccc3(10,10,10)
											 fontsize:16
												  str:@"Click me!"]];
	[freerunmodebutton addChild:first_time_popup];
	[first_time_popup setPosition:[Common pct_of_obj:freerunmodebutton pctx:0.25 pcty:0.9]];

    return self;
}

-(void)cons_wheel_button:(CCMenu*)menu {
	CCSprite *normal = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
											  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																			 idname:@"spinbutton_0"]];
	[normal addChild:[[MenuCommon wheel_of_prizes_button_sprite] anchor_pt:ccp(0,0)]];
	CCSprite *selected = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
												rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																			   idname:@"spinbutton_0"]];
	[selected addChild:[[MenuCommon wheel_of_prizes_button_sprite] anchor_pt:ccp(0,0)]];
	[Common set_zoom_pos_align:normal zoomed:selected scale:1.2];
	
	wheel_ad_button = [CCMenuItemSprite itemFromNormalSprite:normal
																selectedSprite:selected
																		target:self selector:@selector(open_wheel)];
	[wheel_ad_button setScale:0.6];
	[wheel_ad_button setAnchorPoint:ccp(1,1)];
	[wheel_ad_button setPosition:CGPointAdd([Common screen_pctwid:1 pcthei:1],ccp(-5,-5))];
	[menu addChild:wheel_ad_button];
	[wheel_ad_button setVisible:NO];
}

-(void)wheel_ad_button_conditional_setVisible:(BOOL)tar {
	if ([UserInventory get_current_bones] >= [InventoryTabPane_Prizes get_spin_cost]) {
		[wheel_ad_button setVisible:tar];
	} else {
		[wheel_ad_button setVisible:NO];
	}
}

-(void)open_wheel {
	[GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_INVENTORY] add_i1:InventoryLayerTab_Index_Prizes i2:0]];
}

-(void)cons_highscore_sign {
	
	highscore_sign_base = [CCSprite node];
	[highscore_sign_base setContentSize:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"playpage_highscore_sign"].size];
	[highscore_sign_base setPosition:[Common screen_pctwid:0.87 pcthei:0.51]];
	
	[highscore_sign_base setScale:0.9];
	[self addChild:highscore_sign_base];
	[highscore_sign_base addChild:[Common cons_label_pos:[Common pct_of_obj:highscore_sign_base pctx:0.5 pcty:0.825]
												   color:ccc3(20,20,20)
												fontsize:16
													 str:@"High Scores"]];
	
    CCLabelTTF *highscore_world1_label = [[Common cons_label_pos:[Common pct_of_obj:highscore_sign_base pctx:0.0525 pcty:0.6]
														   color:ccc3(20,20,20)
														fontsize:12
															 str:@"World 1:"] anchor_pt:ccp(0,0.5)];
	[highscore_sign_base addChild:highscore_world1_label];
	[highscore_sign_base addChild:[[Common cons_label_pos:CGPointAdd(highscore_world1_label.position, ccp(highscore_world1_label.boundingBox.size.width + 5,0))
													color:ccc3(255,30,30)
												 fontsize:12
													  str:strf("%d",[ScoreManager get_world_highscore:WorldNum_1])] anchor_pt:ccp(0,0.5)]];
	
	
    CCLabelTTF *highscore_world2_label = [[Common cons_label_pos:[Common pct_of_obj:highscore_sign_base pctx:0.0525 pcty:0.45]
														   color:ccc3(20,20,20)
														fontsize:12
															 str:@"World 2:"] anchor_pt:ccp(0,0.5)];
	[highscore_sign_base addChild:highscore_world2_label];
	[highscore_sign_base addChild:[[Common cons_label_pos:CGPointAdd(highscore_world2_label.position, ccp(highscore_world2_label.boundingBox.size.width + 5,0))
													color:ccc3(255,30,30)
												 fontsize:12
													  str:strf("%d",[ScoreManager get_world_highscore:WorldNum_2])] anchor_pt:ccp(0,0.5)]];
	
    CCLabelTTF *highscore_world3_label = [[Common cons_label_pos:[Common pct_of_obj:highscore_sign_base pctx:0.0525 pcty:0.3]
														   color:ccc3(20,20,20)
														fontsize:12
															 str:@"World 3:"] anchor_pt:ccp(0,0.5)];
	[highscore_sign_base addChild:highscore_world3_label];
	[highscore_sign_base addChild:[[Common cons_label_pos:CGPointAdd(highscore_world3_label.position, ccp(highscore_world3_label.boundingBox.size.width + 5,0))
													color:ccc3(255,30,30)
												 fontsize:12
													  str:strf("%d",[ScoreManager get_world_highscore:WorldNum_3])] anchor_pt:ccp(0,0.5)]];
}

-(void)startworlddispbutton_pressed {
	[MenuCommon goto_map];
}

-(void)startbonusdispbutton_pressed {
	[MenuCommon goto_shop];
}

-(void)setVisible:(BOOL)visible {
	if (visible) {
		[startworld_disp set_string:[FreeRunStartAtManager name_for_loc:[FreeRunStartAtManager get_starting_loc]]];
		TexRect *tr = [FreeRunStartAtManager get_icon_for_loc:[FreeRunStartAtManager get_starting_loc]];
		[startworld_disp_icon set_texture:tr.tex];
		[startworld_disp_icon set_texturerect:tr.rect];
		
		[first_time_popup setVisible:[FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_TUTORIAL];
		
		[challenges_completed_disp setString:[NSString stringWithFormat:@"%d/%d",[ChallengeRecord get_highest_available_challenge],[ChallengeRecord get_num_challenges]]];
	}
	[super setVisible:visible];
}

-(void)challengemode_button_button_pressed {
	[AudioManager playsfx:SFX_MENU_UP];
    cur_mode = PlayPageMode_CHALLENGE_SELECT;
}

-(void)repeatbounce {
    [logo stopAllActions];
    [logo runAction:[self cons_logobounce_anim]];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_TICK && self.visible) {
        [self update:e.f1];
        
    } else if (e.type == GEventType_MENU_GOTO_PAGE && e.i1 == MENU_STARTING_PAGE_ID) {
        cur_mode = PlayPageMode_WAIT;
        
    } else if (e.type == GEventType_MENU_INVENTORY) {
        kill = YES;
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        kill = NO;
        
    } else if (e.type == GEventType_SELECTED_CHALLENGELEVEL) {
		play_mode_type = [[GEvent cons_type:GEventType_MENU_PLAY_CHALLENGELEVEL_MODE] add_i1:e.i1 i2:0];
		[self prep_runout_anim];
		
	} else if (e.type == GEventType_MENU_SCROLLBGUP_PCT) {
		 [highscore_sign_base setPosition:ccp(highscore_sign_base.position.x,-500*e.f1)];
		
	}
}

#define DOG_START ccp(0,80)
#define DOG_END_X 600

-(void)update:(ccTime)dt {
    [Common set_dt:dt];
    if (kill) {
        [logo_base setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
		[self wheel_ad_button_conditional_setVisible:NO];
        
    } else if (cur_mode == PlayPageMode_WAIT) {
        [logo_base setVisible:YES];
        [playbutton setVisible:YES];
        [nav_menu setVisible:YES];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
		[self wheel_ad_button_conditional_setVisible:YES];
    
    } else if (cur_mode == PlayPageMode_DOGRUN) {
        [logo_base setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
		[self wheel_ad_button_conditional_setVisible:NO];
        
        if (rundog.position.x > 200 && ![birds get_activated]) {
            [birds activate_birds];
        }
        [birds update:NULL g:NULL];
        [rundog setPosition:ccp(rundog.position.x+15,rundog.position.y)];
        
        ct++;
        if (ct%3==0) {
            Vec3D dv = [VecLib cons_x:-5 y:0 z:0];
            dv.x += float_random(-3, 3);
            dv.y += float_random(0, 5);
            [GEventDispatcher push_event:
             [[[GEvent cons_type:GEventType_MENU_MAKERUNPARTICLE] add_pt:ccp(rundog.position.x-20,rundog.position.y)] add_f1:dv.x f2:dv.y]];
        }
        
        
        if (rundog.position.x > DOG_END_X) {
            cur_mode = PlayPageMode_SCROLLUP;
            [self removeChildByTag:tDHMASK cleanup:YES];
            [self removeChildByTag:tFLOWER cleanup:YES];
        }
        
    } else if (cur_mode == PlayPageMode_SCROLLUP) {
        [logo_base setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [birds setVisible:NO];
        [challengeselect setVisible:NO];
		[self wheel_ad_button_conditional_setVisible:NO];
        
        scrollup_pct+=0.04;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_SCROLLBGUP_PCT] add_f1:scrollup_pct f2:0]];
        
        if (scrollup_pct >= 1) {
			if (play_mode_type == NULL) NSLog(@"error, play_mode_type in NMenuPlayPage is null at end of runout anim");
			[GEventDispatcher push_event:play_mode_type];
        }
        
    } else if (cur_mode == PlayPageMode_MODE_CHOOSE) {
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [logo_base setVisible:YES];
        [mode_choose_menu setVisible:YES];
        [challengeselect setVisible:NO];
		[self wheel_ad_button_conditional_setVisible:YES];
        
    } else if (cur_mode == PlayPageMode_CHALLENGE_SELECT) {
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [logo_base setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:YES];
		[self wheel_ad_button_conditional_setVisible:NO];
        
    } else if (cur_mode == PlayPageMode_CHALLENGE_VIEW) {
        
        
    }
}

-(void)run_button_pressed {
	[AudioManager playsfx:SFX_MENU_UP];
    cur_mode = PlayPageMode_MODE_CHOOSE;
}

-(void)freerun_button_pressed {
	play_mode_type = [GEvent cons_type:GEventType_MENU_PLAY_AUTOLEVEL_MODE];
	[self prep_runout_anim];
}

-(void)prep_runout_anim {
	 cur_mode = PlayPageMode_DOGRUN;
    [logo setVisible:NO];
    [playbutton setVisible:NO];
    [nav_menu setVisible:NO];
    [mode_choose_menu setVisible:NO];
    
    CCSprite *body = [CCSprite node];
    [body runAction:[self cons_anim:[Player get_character]]];
    [body setAnchorPoint:ccp(0.5,0)];
    
    [rundog setPosition:DOG_START];
    [rundog setAnchorPoint:ccp(0.2,0.2)];
    
    CCSprite *shad = [CCSprite spriteWithTexture:[Resource get_tex:TEX_DOG_SHADOW]];
    [shad setOpacity:70];
    [shad setPosition:ccp(-5,0)];
    [shad setScale:1.25];
    
    [rundog addChild:shad];
    [rundog addChild:body];
    [self addChild:rundog];
    
    CCSprite *dhmask = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_DOGHOUSEMASK]];
    [dhmask setAnchorPoint:ccp(0,0)];
	[dhmask setScaleX:[Common scale_from_default].x];
	[dhmask setScaleY:[Common scale_from_default].y];
    [self addChild:dhmask z:1 tag:tDHMASK];
	
	[Player character_bark];
	[AudioManager playsfx:SFX_CHECKPOINT];
}

-(CCAction*)cons_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_2"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_3"]]];
    return [Common make_anim_frames:animFrames speed:0.025];
}

-(CCAnimate*)cons_logojump_anim {
	NSString *tar = TEX_INTRO_ANIM_SS;
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_2"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_3"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_4"]]];
    return [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:0.1] restoreOriginalFrame:NO];
}

-(CCAnimate*)cons_logobounce_anim {
    NSString *tar = TEX_INTRO_ANIM_SS;
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_5"]]];
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_6"]]];
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_7"]]];
    }
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"logo_headcircle_8"]]];
    return [Common make_anim_frames:animFrames speed:0.15];
}

-(void)null_selector{}

-(void)dealloc {
	[self removeAllChildrenWithCleanup:YES];
}

@end
