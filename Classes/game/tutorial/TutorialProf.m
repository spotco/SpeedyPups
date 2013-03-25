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

//#define TARGET_POS ccp(420,150)
//#define STARTING_POS ccp(720,450)
#define FLYIN_SPEED 10
#define MESSAGELENGTH 250

+(TutorialProf*)cons_msg:(NSString *)msg y:(float)y {
    TutorialProf *p = [[TutorialProf node] cons_msg:msg y:y];
    [GEventDispatcher add_listener:p];
    return p;
}

-(id)cons_msg:(NSString *)msg y:(float)y{
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
    
    
    messageanim = [msg isEqualToString:@"random"]?[TutorialAnim cons_msg:[self _tmp_msg_random]]:[TutorialAnim cons_msg:msg];
    
    [messageanim setPosition:ccp(180,100)];
    [messagebubble addChild:messageanim];
    
    TAR = ccp(420,y);  //x is relative, y is not
    START = ccp(720,y+450);
    curpos = START;
    
    curstate = TutorialProf_FLYIN;
    return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    [super update:player g:g];
    if (shadow == NULL) {
        shadow = [ProfShadow cons_tar:self];
        [g add_gameobject:shadow];
    }
    
    [self update_vibration];
    
    
    if (curstate == TutorialProf_FLYIN) {
        [messagebubble setVisible:NO];
        if (CGPointDist(curpos, TAR)>10) {
            CGPoint delta = ccp((TAR.x-curpos.x)/FLYIN_SPEED,(TAR.y-curpos.y)/FLYIN_SPEED);
            curpos = CGPointAdd(curpos, delta);
            [self setPosition:ccp(player.position.x+curpos.x+vibration.x,curpos.y+vibration.y)];
        } else {
            curstate = TutorialProf_MESSAGE;
            ct = MESSAGELENGTH;
            [self setPosition:ccp(player.position.x+curpos.x+vibration.x,curpos.y+vibration.y)];
        }
        
        
    } else if (curstate == TutorialProf_MESSAGE) {
        [messagebubble setVisible:YES];
        [messageanim update];
        ct--;
        if (ct <= 0) {
            curstate = TutorialProf_FLYOUT;
        }
        
        [self setPosition:ccp(player.position.x+curpos.x+vibration.x,curpos.y+vibration.y)];
        
    } else if (curstate == TutorialProf_FLYOUT) {
        [messagebubble setVisible:NO];
        if (CGPointDist(curpos, START)>10) {
            CGPoint delta = ccp((START.x-curpos.x)/FLYIN_SPEED,(START.y-curpos.y)/FLYIN_SPEED);
            curpos = CGPointAdd(curpos, delta);
            [self setPosition:ccp(player.position.x+curpos.x+vibration.x,curpos.y+vibration.y)];
        } else {
            [self remove];
            return;
        }
    }
}

-(void)check_should_render:(GameEngineLayer *)g {
    do_render = YES;
}


-(void)update_vibration {
    vibration_ct+=0.1;
    vibration.y = 2.5*sinf(vibration_ct);
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_END_TUTORIAL) {
        curstate = TutorialProf_FLYOUT;
    }
}

-(void)remove {
    [((GameEngineLayer*)self.parent) remove_gameobject:shadow];
    [((GameEngineLayer*)self.parent) remove_gameobject:self];
    [GEventDispatcher remove_listener:self];
    
}

-(void)reset {
    [super reset];
    [self remove];
}

-(CCAction*)cons_anim_tar:(NSString*)tar frames:(NSArray*)a speed:(float)speed {
	CCTexture2D *texture = [Resource get_tex:tar];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:k]]];
    return [Common make_anim_frames:animFrames speed:speed];
}

static NSArray *_tmp_msglist;
-(NSString*)_tmp_msg_random {
    if (_tmp_msglist == NULL) {
        _tmp_msglist = [NSArray arrayWithObjects:@"doublejump",@"minionhit",@"minionjump",@"rockbreak",@"rockethit",@"rocketjump",@"rockhit",@"spikehit",@"spikevine",@"splash",@"hover",@"jump",@"swingvine",@"swipe_down",@"swipe_straight", nil];
    }
    return [_tmp_msglist objectAtIndex:int_random(0, [_tmp_msglist count])];
}

@end
