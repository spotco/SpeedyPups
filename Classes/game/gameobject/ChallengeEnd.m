#import "ChallengeEnd.h"
#import "Challenge.h" 
#import "GameEngineLayer.h" 

@implementation ChallengeEnd

+(ChallengeEnd*)cons_pt:(CGPoint)pt {
    ChallengeEnd* c = [ChallengeEnd node];
    [c setPosition:pt];
    return c;
}

-(id)init {
    self = [super init];
    body = [Common cons_render_obj:[Resource get_tex:TEX_CHECKERBOARD] npts:4];
    /**
     32
     10
     **/
    body.tri_pts[0] = ccp(50,-1000);
    body.tri_pts[1] = ccp(0,-1000);
    body.tri_pts[2] = ccp(50,2000);
    body.tri_pts[3] = ccp(0,2000);
    
    body.tex_pts[0] = ccp(1,body.tri_pts[0].y/body.texture.pixelsHigh);
    body.tex_pts[1] = ccp(0,body.tri_pts[1].y/body.texture.pixelsHigh);
    body.tex_pts[2] = ccp(1,body.tri_pts[2].y/body.texture.pixelsHigh);
    body.tex_pts[3] = ccp(0,body.tri_pts[3].y/body.texture.pixelsHigh);
    procced = NO;
    return self;
}

-(void)check_should_render:(GameEngineLayer *)g {
    do_render = YES;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_BTWN_PLAYER_ISLAND];
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x y1:position_.y wid:100 hei:1000];
}

-(void)notify_challenge_mode:(ChallengeInfo *)c {
    active = YES;
    info = c;
    NSLog(@"Challenge:%@",[info to_string]);
}

-(void)update:(Player*)player g:(GameEngineLayer *)g {
    [super update:player g:g];
    if (active && !procced && [Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]) {
        procced = YES;
        [GEventDispatcher push_event:
         [[[GEvent cons_type:GEventType_CHALLENGE_COMPLETE]
          add_i1:[self did_complete_challenge:g] i2:0]
          add_key:@"challenge" value:info]
         ];
    }
    
    return;
}

-(BOOL)did_complete_challenge:(GameEngineLayer*)g {
    if (info.type == ChallengeType_COLLECT_BONES) {
        return [g get_num_bones] >= info.ct;
    
    } else if (info.type == ChallengeType_FIND_SECRET) {
        return NO;
        
    } else if (info.type == ChallengeType_TIMED) {
        return [g get_time] <= info.ct;
        
    }
    return NO;

}

-(void)reset {
    procced = NO;
}

-(void)draw {
    if(!active)return;
    [super draw];
    [Common draw_renderobj:body n_vtx:4];
}

@end
