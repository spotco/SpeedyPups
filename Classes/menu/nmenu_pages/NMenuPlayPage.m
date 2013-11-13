#import "NMenuPlayPage.h"
#import "MenuCommon.h"
#import "Flowers.h"
#import "GameMain.h"
#import "FreeRunStartAtManager.h"

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
    
    logo = [CCSprite node];
    id reptrig = [CCCallFunc actionWithTarget:self selector:@selector(repeatbounce)];
    [logo runAction:[CCSequence actions:[self cons_logojump_anim:TEX_NMENU_LOGO],reptrig, nil]];
    [logo setPosition:[Common screen_pctwid:0.5 pcthei:0.75]];
    [self addChild:logo];
    
    
    playbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_runbutton"
                                               tar:self sel:@selector(run_button_pressed)
                                               pos:[Common screen_pctwid:0.5 pcthei:0.4]];
    
    nav_menu = [MenuCommon cons_common_nav_menu];
    [self addChild:nav_menu z:5];
    
    [self addChild:[Flowers cons_pt:[Common screen_pctwid:0.275 pcthei:0.35]] z:0 tag:tFLOWER];
    
    birds = [BirdFlock cons_x:[Common SCREEN].width*0.8 y:[Common SCREEN].height*0.25];
    [birds setScale:0.75];
    [self addChild:birds];
    
    CCMenu *m = [CCMenu menuWithItems:playbutton, nil];
    [m setPosition:ccp(0,0)];
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
	
	#define TOPRIGHTLABEL(x) [[Common cons_label_pos:[Common pct_of_obj:startworlddisp pctx:0.5 pcty:0.78] color:ccc3(0,0,0) fontsize:14 str:x] anchor_pt:ccp(0.5,1)]
	CCLabelTTF *startworlddisp_a = TOPRIGHTLABEL(@"");
	CCLabelTTF *startworlddisp_b = TOPRIGHTLABEL(@"");
	[startworlddisp.normalImage addChild:startworlddisp_a];
	[startworlddisp.selectedImage addChild:startworlddisp_b];
	startworld_disp = [[[[LabelGroup alloc] init] add_label:startworlddisp_a] add_label:startworlddisp_b];
	[startworld_disp set_string:@""];
	
	#define SPRITEICON(x) [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"icon_tutorial"]] pos:[Common pct_of_obj:startworlddisp pctx:0.5 pcty:0.33]]
	CCSprite *swdispicon_a = SPRITEICON(@"icon_tutorial");
	CCSprite *swdispicon_b = SPRITEICON(@"icon_tutorial");
	startworld_disp_icon = [[[[SpriteGroup alloc] init] add_sprite:swdispicon_a] add_sprite:swdispicon_b];
	[startworlddisp.normalImage addChild:swdispicon_a];
	[startworlddisp.selectedImage addChild:swdispicon_b];
	
	
	CCSprite *challengescompleteddisp = [CCSprite node];
	CCSprite *chcodis_body = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"playpage_infoside"]];
	[chcodis_body setScaleX:-1];
	[challengescompleteddisp addChild:chcodis_body];
	[chcodis_body setPosition:[Common pct_of_obj:chcodis_body pctx:0.5 pcty:0]];
	[challengescompleteddisp setPosition:ccp(challengemodebutton.position.x + challengemodebutton.boundingBox.size.width/2.0 - 10,challengemodebutton.position.y)];
	CCMenuItemImage *challengecompletedisp_wrapper = [CCMenuItemImage itemWithTarget:self selector:@selector(null_selector)];
	[challengecompletedisp_wrapper addChild:challengescompleteddisp];
	[challengescompleteddisp addChild:[[Common cons_label_pos:[Common pct_of_obj:chcodis_body pctx:0.9 pcty:0.93-0.5]
														color:ccc3(200,30,30)
													 fontsize:9 str:@"Completed:"] anchor_pt:ccp(1,1)]];
	challenges_completed_disp = [Common cons_label_pos:[Common pct_of_obj:chcodis_body pctx:0.55 pcty:0.5-0.5]
												 color:ccc3(0,0,0)
											  fontsize:20
												   str:@"00/00"];
	[challengescompleteddisp addChild:challenges_completed_disp];
	
    mode_choose_menu = [CCMenu menuWithItems:startworlddisp,challengecompletedisp_wrapper,freerunmodebutton,challengemodebutton,nil];
    [mode_choose_menu setPosition:ccp(0,0)];
    [self addChild:mode_choose_menu];
    [mode_choose_menu setVisible:NO];
    
    challengeselect = [ChallengeModeSelect cons];
    [challengeselect setVisible:NO];
    [self addChild:challengeselect];
    
    return self;
}

-(void)startworlddispbutton_pressed {
	[MenuCommon goto_settings];
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
    [logo runAction:[self cons_logobounce_anim:TEX_NMENU_LOGO]];
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
		
	}
}

#define DOG_START ccp(0,80)
#define DOG_END_X 600

-(void)update:(ccTime)dt {
    [Common set_dt:dt];
    if (kill) {
        [logo setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
        
    } else if (cur_mode == PlayPageMode_WAIT) {
        [logo setVisible:YES];
        [playbutton setVisible:YES];
        [nav_menu setVisible:YES];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
    
    } else if (cur_mode == PlayPageMode_DOGRUN) {
        [logo setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:NO];
        
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
        [logo setVisible:NO];
        [playbutton setVisible:NO];
        [nav_menu setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [birds setVisible:NO];
        [challengeselect setVisible:NO];
        
        scrollup_pct+=0.04;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_SCROLLBGUP_PCT] add_f1:scrollup_pct f2:0]];
        
        if (scrollup_pct >= 1) {
			if (play_mode_type == NULL) NSLog(@"error, play_mode_type in NMenuPlayPage is null at end of runout anim");
			[GEventDispatcher push_event:play_mode_type];
        }
        
    } else if (cur_mode == PlayPageMode_MODE_CHOOSE) {
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [logo setVisible:YES];
        [mode_choose_menu setVisible:YES];
        [challengeselect setVisible:NO];
        
    } else if (cur_mode == PlayPageMode_CHALLENGE_SELECT) {
        [playbutton setVisible:NO];
        [nav_menu setVisible:YES];
        [logo setVisible:NO];
        [mode_choose_menu setVisible:NO];
        [challengeselect setVisible:YES];
        
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

-(CCAnimate*)cons_logojump_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation1.png"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation2.png"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation3.png"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation4.png"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation5.png"]]];
    return [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:0.1] restoreOriginalFrame:NO];
}

-(CCAnimate*)cons_logobounce_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation6.png"]]];
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation7.png"]]];
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation8.png"]]];
    }
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"headanimation9.png"]]];
    return [Common make_anim_frames:animFrames speed:0.15];
}

-(void)null_selector{}

@end
