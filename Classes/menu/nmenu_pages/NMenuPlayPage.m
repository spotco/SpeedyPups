#import "NMenuPlayPage.h"
#import "MenuCommon.h"
#import "Flowers.h"

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
                                               pos:[Common screen_pctwid:0.5 pcthei:0.45]];
    
    nav_menu = [MenuCommon cons_common_nav_menu];
    [self addChild:nav_menu];
    
    [self addChild:[Flowers cons_pt:[Common screen_pctwid:0.275 pcthei:0.35]] z:0 tag:tFLOWER];
    
    birds = [BirdFlock cons_x:[Common SCREEN].width*0.8 y:[Common SCREEN].height*0.25];
    [birds setScale:0.75];
    [self addChild:birds];
    
    CCMenu *m = [CCMenu menuWithItems:playbutton, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    
    rundog = [CCSprite node];
    
    CCMenuItem *freerunmodebutton = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ rect:@"infinitemode" tar:self sel:@selector(freerun_button_pressed) pos:[Common screen_pctwid:0.35 pcthei:0.35]];
    [freerunmodebutton addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Free Run"]];
    CCMenuItem *challengemodebutton = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ rect:@"challengemodebutton" tar:self sel:@selector(challengemode_button_button_pressed) pos:[Common screen_pctwid:0.65 pcthei:0.35]];
    [challengemodebutton addChild:[Common cons_label_pos:ccp(50,20) color:ccc3(240, 10, 10) fontsize:15 str:@"Challenge"]];
    
    mode_choose_menu = [CCMenu menuWithItems:freerunmodebutton,challengemodebutton,nil];
    [mode_choose_menu setPosition:ccp(0,0)];
    [self addChild:mode_choose_menu];
    [mode_choose_menu setVisible:NO];
    
    challengeselect = [ChallengeModeSelect cons];
    [challengeselect setVisible:NO];
    [self addChild:challengeselect];
    
    return self;
}

-(void)challengemode_button_button_pressed {
    cur_mode = PlayPageMode_CHALLENGE_SELECT;
}

-(void)repeatbounce {
    [logo stopAllActions];
    [logo runAction:[self cons_logobounce_anim:TEX_NMENU_LOGO]];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_TICK && self.visible) {
        [self update];
        
    } else if (e.type == GEventType_MENU_GOTO_PAGE && e.i1 == MENU_STARTING_PAGE_ID) {
        cur_mode = PlayPageMode_WAIT;
        
    } else if (e.type == GEventType_MENU_INVENTORY) {
        kill = YES;
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        kill = NO;
        
    }
}

#define DOG_START ccp(0,80)
#define DOG_END_X 600

-(void)update {
    
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
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_PLAY_AUTOLEVEL_MODE]];
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
    cur_mode = PlayPageMode_MODE_CHOOSE;
}

-(void)freerun_button_pressed {
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
    [self addChild:dhmask z:1 tag:tDHMASK];
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

@end
