#import "ChallengeEndUI.h"
#import "cocos2d.h" 
#import "Resource.h"
#import "FileCache.h" 
#import "MenuCommon.h"
#import "UILayer.h"
#import "UserInventory.h" 
#import "GameModeCallback.h"
#import "FireworksParticleA.h"

@implementation ChallengeEndUI

+(ChallengeEndUI*)cons {
    return [ChallengeEndUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *complete_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    complete_ui.anchorPoint = ccp(0,0);
    [complete_ui setPosition:ccp(0,0)];
    
    wlicon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                     rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengecomplete"]]
              pos:[Common screen_pctwid:0.5 pcthei:0.8]];
    [complete_ui addChild:wlicon];
    
    CCSprite *infopane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeinfo"]]
                          pos:[Common screen_pctwid:0.5 pcthei:0.4]];
    
    CCLabelTTF *l = [Common cons_label_pos:ccp(220,82) color:ccc3(0,0,0) fontsize:15 str:@"Collected"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    bone_disp = [Common cons_label_pos:ccp(245,85) color:ccc3(220,10,10) fontsize:15 str:@"0"];
    [bone_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:bone_disp];
    
    l = [Common cons_label_pos:ccp(220,58) color:ccc3(0,0,0) fontsize:15 str:@"Time"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    time_disp = [Common cons_label_pos:ccp(230,60) color:ccc3(220,10,10) fontsize:15 str:@"0:00"];
    [time_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:time_disp];
    
    l = [Common cons_label_pos:ccp(220,37) color:ccc3(0,0,0) fontsize:15 str:@"Secrets"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    secrets_disp = [Common cons_label_pos:ccp(230,37) color:ccc3(220,10,10) fontsize:15 str:@"0"];
    [secrets_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:secrets_disp];
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    infodesc = [CCLabelTTF labelWithString:@"Some challenge eh"
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:13];
    [infodesc setColor:ccc3(40,40,40)];
    [infodesc setAnchorPoint:ccp(0,0.5)];
    [infodesc setPosition:ccp(10,67.5)];
    [infopane addChild:infodesc];
    
    maxstr = @"aaaaaaaa\naaaaaaaa\naaaaaaaa";
    actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:25]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    reward_disp = [CCLabelTTF labelWithString:@""
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:25];
    [reward_disp setColor:ccc3(220,220,200)];
    [reward_disp setAnchorPoint:ccp(0,1)];
    [reward_disp setPosition:[Common screen_pctwid:0.05 pcthei:0.95]];
    [complete_ui addChild:reward_disp];
    
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"homebutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.1]];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.5 pcthei:0.1]];
	
	nextbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"nextbutton" tar:self sel:@selector(next)
                                                pos:[Common screen_pctwid:0.7 pcthei:0.1]];
    [nextbutton setVisible:NO];
    CCMenu *m = [CCMenu menuWithItems:backbutton,retrybutton,nextbutton, nil];
    [m setPosition:CGPointZero];
    [complete_ui addChild:m z:1];
    
    [complete_ui addChild:infopane z:1];
    [self addChild:complete_ui];
	
	particleholder = [[CCSprite node] pos:CGPointZero];
	[complete_ui addChild:particleholder];
	particles = [NSMutableArray array];
    particles_tba = [NSMutableArray array];
	
    return self;
}

-(void)update_passed:(BOOL)p info:(ChallengeInfo*)ci bones:(NSString*)bones time:(NSString*)time secrets:(NSString*)secrets {
	[AudioManager playbgm:BGM_GROUP_JINGLE];
	
	[wlicon setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:p?@"challengecomplete":@"challengefailed"]];
    [infodesc setString:[ci to_string]];
    [bone_disp setString:bones];
    [time_disp setString:time];
    [secrets_disp setString:secrets];
    
    curchallenge = [ChallengeRecord get_number_for_challenge:ci];
    if (p == YES && ![ChallengeRecord get_beaten_challenge:curchallenge]) {
        [ChallengeRecord set_beaten_challenge:curchallenge to:YES];
        [UserInventory add_bones:ci.reward];
        [reward_disp setString:[NSString stringWithFormat:@"Earned %d bones!",ci.reward]];
    }
	
	if ([ChallengeRecord get_beaten_challenge:curchallenge] &&
		curchallenge + 1 < [ChallengeRecord get_num_challenges]
		) {
		[nextbutton setVisible:YES];
	}
	
	sto_passed = p;
}

-(BOOL)get_sto_passed {
	return sto_passed;
}

-(void)next {
	if (curchallenge+1<[ChallengeRecord get_num_challenges])
		[(UILayer*)[self parent] run_cb:[GameModeCallback cons_mode:GameMode_CHALLENGE n:curchallenge+1]];
}

-(void)retry {
    [(UILayer*)[self parent] retry];
}

-(void)exit_to_menu {
    [(UILayer*)[self parent] exit_to_menu];
}

static int delayfwct;
-(void)start_fireworks_effect {
	if (!has_scheduler) {
		[self schedule:@selector(update_particles)];
		has_scheduler = YES;
	}
	
	[self add_firework_at_xpct:0.15];
	[self add_firework_at_xpct:0.85];
	delayfwct = 0;
}
-(void)add_firework_at_xpct:(float)xpct {
	[self add_particle:[FireworksParticleA cons_x:[Common SCREEN].width*xpct + float_random(-50, 50)
												y:0
											   vx:0
											   vy:float_random(9,14)
											   ct:arc4random_uniform(8)+17]];
}
-(void)add_particle:(Particle*)p {
    [particles_tba addObject:p];
}
-(int)get_num_particles {
    return [particles count];
}
-(void)push_added_particles {
    for (Particle *p in particles_tba) {
        [particles addObject:p];
        [particleholder addChild:p z:[p get_render_ord]];
    }
    [particles_tba removeAllObjects];
}
-(void)update_particles {
	delayfwct++;
	if (delayfwct==10) {
		[self add_firework_at_xpct:0.15];
	} else if (delayfwct == 17) {
		[self add_firework_at_xpct:0.85];
	} else if (delayfwct == 23) {
		[self add_firework_at_xpct:0.15];
	} else if (delayfwct == 29) {
		[self add_firework_at_xpct:0.85];
	}
	[self push_added_particles];
    NSMutableArray *toremove = [NSMutableArray array];
    for (Particle *i in particles) {
        [i update:(id)self]; //don't do this at home
        if ([i should_remove]) {
            [particleholder removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [particles removeObjectsInArray:toremove];
	if (particles.count == 0) {
		[self unschedule:@selector(update_particles)];
		has_scheduler = NO;
	}
}

@end
