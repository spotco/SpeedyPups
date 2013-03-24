#import "TutorialAnim.h"
#import "Resource.h"
#import "FileCache.h"

@implementation TutorialAnim
#define NOSHOW ccp(0.1,0.1)

+(TutorialAnim*)cons_msg:(NSString*)msg {
    return [[TutorialAnim node]cons:msg];
}

-(id)cons:(NSString*)msg {
    body = [CCSprite node];
    hand = [CCSprite node];
    effect = [CCSprite node];
    nosign = [CCSprite node];
    
    if ([msg isEqualToString:@"doublejump"]) {
        NSArray* tbodyframes = [NSArray arrayWithObjects:  @""     ,@""     ,@""     ,@"dbljump0",@"dbljump2" ,@"dbljump3" ,@"dbljump4",@"dbljump5",@"dbljump6",@"dbljump7",@"dbljump8",@"dbljump9",@"dbljump10",nil];
        NSArray* teffectframes = [NSArray arrayWithObjects:@""     ,@""     ,@""     ,@""        ,@"jump"     ,@"jump"     ,@""        ,@""        ,@"jump"    ,@"jump"    ,@""        ,@""        ,@""         ,nil];
        CGPoint handframes[] =                            {ccp(0,0),ccp(0,0),ccp(0,0),ccp(-6,0)  ,ccp(-12,0)  ,ccp(-6,0)   ,ccp(0,0)   ,ccp(-6,0)  ,ccp(-12,0) ,ccp(-6,0)  ,ccp(0,0)   ,ccp(0,0)   ,ccp(0,0)    };
        CGPoint nosignfr[] =                              {NOSHOW  ,NOSHOW  ,NOSHOW  ,NOSHOW     ,NOSHOW      ,NOSHOW      ,NOSHOW     ,NOSHOW     ,NOSHOW     ,NOSHOW     ,NOSHOW     ,NOSHOW     ,NOSHOW      };
        
        [body setPosition:ccp(0,15)];
        [effect setPosition:ccp(50,-50)];
        defaulthandpos = ccp(100,-100);
        [self make_anim_body:tbodyframes effect:teffectframes hand:handframes nosign:nosignfr src:TEX_TUTORIAL_ANIM_1];
        
    } else if ([msg isEqualToString:@"minionhit"]) {
        NSArray* tbodyframes = [NSArray arrayWithObjects:  @""     ,@""     ,@""     ,@"minionhit0",@"minionhit1",@"minionhit2",@"minionhit3",@"minionhit4",@"minionhit5",@"minionhit6",@"minionhit7",@"minionhit7",@"minionhit7",@"minionhit7",nil];
        NSArray* teffectframes = [NSArray arrayWithObjects:@""     ,@""     ,@""     ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,@""          ,nil];
        CGPoint handframes[] =                            {NOSHOW  ,NOSHOW  ,NOSHOW  ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW};
        CGPoint nosignfr[] =                              {NOSHOW  ,NOSHOW  ,NOSHOW  ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,NOSHOW       ,ccp(0,0)     ,ccp(0,0)     ,ccp(0,0)};
        
        [body setPosition:ccp(-20,-10)];
        [self make_anim_body:tbodyframes effect:teffectframes hand:handframes nosign:nosignfr src:TEX_TUTORIAL_ANIM_1];
        
    } else {
        NSLog(@"ERROR TUTORIAL NOT FOUND:%@",msg);
    }
    return self;
}

-(void)update {
    animdelayct++;
    if (animdelayct >= animspeed) {
        curframe=curframe+1>=animlen?0:curframe+1;
        [body setTextureRect:frames[curframe]];
        [effect setTextureRect:effectframes[curframe]];
        
        [hand setPosition:CGPointAdd(defaulthandpos, handposframes[curframe])];
        [hand setVisible:!CGPointEqualToPoint(handposframes[curframe], NOSHOW)];
        
        [nosign setPosition:nosignframes[curframe]];
        [nosign setVisible:!CGPointEqualToPoint(nosignframes[curframe], NOSHOW)];
        
        animdelayct=0;
        
    } else {
        animdelayct++;
        
    }
}

-(void)make_anim_body:(NSArray*)tbodyframes effect:(NSArray*)teffectframes hand:(CGPoint*)handframes nosign:(CGPoint*)nosignf src:(NSString*)src {
    [self cons_body_anim_tar:src frames:tbodyframes speed:10];
    [self addChild:body];
    
    [self cons_effect_anim:TEX_TUTORIAL_OBJ frames:teffectframes];
    [self addChild:effect];
    
    [self cons_hand_anim:handframes];
    [hand setPosition:CGPointAdd(defaulthandpos, handposframes[curframe])];
    [self addChild:hand];
    
    [self cons_nosign_anim:nosignf];
    [self addChild:nosign];
}

-(void)cons_nosign_anim:(CGPoint*)poss {
    [nosign setTexture:[Resource get_tex:TEX_TUTORIAL_OBJ]];
    [nosign setTextureRect:[FileCache get_cgrect_from_plist:TEX_TUTORIAL_OBJ idname:@"nosign"]];
    [nosign setScale:1];
    nosignframes= malloc(sizeof(CGPoint)*animlen);
    for(int i = 0; i < animlen; i++) {
        nosignframes[i] = poss[i];
    }
    [nosign setVisible:NO];
}

-(void)cons_hand_anim:(CGPoint*)poss {
    [hand setTexture:[Resource get_tex:TEX_TUTORIAL_OBJ]];
    [hand setTextureRect:[FileCache get_cgrect_from_plist:TEX_TUTORIAL_OBJ idname:@"hand"]];
    [hand setScale:0.75];
    handposframes = malloc(sizeof(CGPoint)*animlen);
    for(int i = 0; i < animlen; i++) {
        handposframes[i] = poss[i];
    }
    [hand setVisible:NO];
}

-(void)cons_effect_anim:(NSString*)tar frames:(NSArray*)a {
    effectframes = malloc(sizeof(CGRect)*animlen);
    for(int i = 0; i < animlen; i++) {
        effectframes[i] = [FileCache get_cgrect_from_plist:tar idname:[a objectAtIndex:i]];
    }
    [effect setTexture:[Resource get_tex:tar]];
    [effect setTextureRect:effectframes[curframe]];
}

-(void)cons_body_anim_tar:(NSString*)tar frames:(NSArray*)a speed:(int)speed {
    frames = malloc(sizeof(CGRect)*[a count]);
    animlen = [a count];
    curframe = 0;
    animspeed = speed;
    
    for (int i = 0; i < [a count]; i++) {
        frames[i] = [FileCache get_cgrect_from_plist:tar idname:[a objectAtIndex:i]];
    }
    [body setTexture:[Resource get_tex:tar]];
    [body setTextureRect:frames[curframe]];
}

-(void)dealloc {
    free(frames);
    free(effectframes);
    free(handposframes);
    free(nosignframes);
}

@end
