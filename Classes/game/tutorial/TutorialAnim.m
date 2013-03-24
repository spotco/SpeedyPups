#import "TutorialAnim.h"
#import "Resource.h"
#import "FileCache.h"

@implementation TutorialAnim

+(TutorialAnim*)cons_msg:(NSString*)msg {
    return [[TutorialAnim node]cons:msg];
}

-(id)cons:(NSString*)msg {
    body = [CCSprite node];
    hand = [CCSprite node];
    effect = [CCSprite node];
    
    if ([msg isEqualToString:@"doublejump"]) {
        [self cons_body_anim_tar:TEX_TUTORIAL_ANIM_1
                     frames:[NSArray arrayWithObjects:@"dbljump0",@"dbljump2",@"dbljump3",@"dbljump4",@"dbljump5",@"dbljump6",@"dbljump7",@"dbljump8",@"dbljump9",@"dbljump10",nil]
                      speed:10];
        [body setPosition:ccp(0,15)];
        [self addChild:body];
        
        [self cons_effect_anim:TEX_TUTORIAL_OBJ
                        frames:[NSArray arrayWithObjects:@"",@"jump",@"jump",@"",@"",@"jump",@"jump",@"",@"",@"", nil]];
        [effect setPosition:ccp(50,-50)];
        [self addChild:effect];

    }
    return self;
}

-(void)update {
    animdelayct++;
    if (animdelayct >= animspeed) {
        curframe=curframe+1>=animlen?0:curframe+1;
        [body setTextureRect:frames[curframe]];
        [effect setTextureRect:effectframes[curframe]];
        animdelayct=0;
        
    } else {
        animdelayct++;
        
    }
}

-(void)cons_effect_anim:(NSString*)tar frames:(NSArray*)a {
    effectframes = malloc(sizeof(CGRect)*[a count]);
    for(int i = 0; i < [a count]; i++) {
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
}

@end
