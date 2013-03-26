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
    
    logo = [MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_logo" pos:[Common screen_pctwid:0.5 pcthei:0.8]];
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
    
    return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_TICK && self.visible) {
        [self update];
    }
}

#define DOG_START ccp(0,80)
#define DOG_END_X 600

-(void)update {
    if (cur_mode == PlayPageMode_DOGRUN) {
        if (rundog.position.x > 200 && ![birds get_activated]) {
            [birds activate_birds];
        }
        for(int i=0;i<2;i++)[birds update:NULL g:NULL];
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
        [birds setVisible:NO];
        scrollup_pct+=0.04;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_SCROLLBGUP_PCT] add_f1:scrollup_pct f2:0]];
        
        if (scrollup_pct >= 1) {
            [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_PLAY_AUTOLEVEL_MODE]];
        }
        
    }
}

-(void)run_button_pressed {
    cur_mode = PlayPageMode_DOGRUN;
    [logo setVisible:NO];
    [playbutton setVisible:NO];
    [nav_menu setVisible:NO];
    
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

@end
