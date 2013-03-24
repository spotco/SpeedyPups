#import "TutorialProf.h"
#import "GameEngineLayer.h"
#import "TutorialAnim.h"
#import "DogShadow.h"

@interface ProfShadow : ObjectShadow
@end
@implementation ProfShadow
+(ObjectShadow*)cons_tar:(GameObject *)o { return [[ProfShadow node] cons_tar:o]; }
-(void)update_scale:(shadowinfo)v { [super update_scale:v]; [self setScale:self.scale*4]; }
@end

@implementation TutorialProf

#define TARGET_POS ccp(420,150)
#define STARTING_POS ccp(720,450)
#define FLYIN_SPEED 10
#define MESSAGELENGTH 250

+(TutorialProf*)cons_msg:(NSString *)msg {
    return [[TutorialProf node] cons_msg:msg];
}

-(id)cons_msg:(NSString *)msg {
    body = [CCSprite spriteWithTexture:[Resource get_tex:TEX_TUTORIAL_OBJ]
                                  rect:[FileCache get_cgrect_from_plist:TEX_TUTORIAL_OBJ idname:@"professor"]];
    [body setScale:0.75];
    [self addChild:body];
    
    messagebubble = [CCSprite node];
    [messagebubble runAction:[self cons_anim_tar:TEX_TUTORIAL_OBJ
                                          frames:[NSArray arrayWithObjects:@"cloud0",@"cloud1",nil]
                                           speed:0.5]];
    [messagebubble setPosition:ccp(-250,75)];
    [self addChild:messagebubble];
    
    messageanim = [TutorialAnim cons_msg:@"doublejump"];
    [messageanim setPosition:ccp(180,100)];
    [messagebubble addChild:messageanim];
    
    body_rel_pos = STARTING_POS;
    curstate = TutorialProf_FLYIN;
    return self;
}

-(void)check_should_render:(GameEngineLayer *)g {
    do_render = YES;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_ABOVE_FG_ORD];
}

-(void)update_vibration {
    vibration_ct+=0.1;
    vibration.y = 2.5*sinf(vibration_ct);
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    [super update:player g:g];
    if (shadow == NULL) {
        shadow = [ProfShadow cons_tar:self];
        [g add_gameobject:shadow];
    }
    
    
    if (curstate == TutorialProf_FLYIN) {
        [messagebubble setVisible:NO];
        if (CGPointDist(TARGET_POS, body_rel_pos)>10) {
            CGPoint delta = ccp((TARGET_POS.x-body_rel_pos.x)/FLYIN_SPEED,(TARGET_POS.y-body_rel_pos.y)/FLYIN_SPEED);
            body_rel_pos = CGPointAdd(body_rel_pos,delta);
        } else {
            body_rel_pos = TARGET_POS;
            curstate = TutorialProf_MESSAGE;
            ct = MESSAGELENGTH;
        }
        
    } else if (curstate == TutorialProf_MESSAGE) {
        [messagebubble setVisible:YES];
        [messageanim update];
        ct--;
        if (ct <= 0) {
            curstate = TutorialProf_FLYOUT;
        }
        
    } else if (curstate == TutorialProf_FLYOUT) {
        [messagebubble setVisible:NO];
        if (CGPointDist(STARTING_POS, body_rel_pos)>10) {
            CGPoint delta = ccp((STARTING_POS.x-body_rel_pos.x)/FLYIN_SPEED,(STARTING_POS.y-body_rel_pos.y)/FLYIN_SPEED);
            body_rel_pos = CGPointAdd(body_rel_pos,delta);
        } else {
            [g remove_gameobject:self];
            return;
        }
    }
    
    [self update_vibration];
    CGPoint relpos = CGPointAdd(body_rel_pos, vibration);
    
    [self setPosition:CGPointAdd(player.position, relpos)];
}

-(void)reset {
    [super reset];
    [((GameEngineLayer*)self.parent) remove_gameobject:self];
}

-(CCAction*)cons_anim_tar:(NSString*)tar frames:(NSArray*)a speed:(float)speed {
	CCTexture2D *texture = [Resource get_tex:tar];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:k]]];
    return [Common make_anim_frames:animFrames speed:speed];
}

@end
