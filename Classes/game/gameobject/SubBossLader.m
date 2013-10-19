#import "SubBossLader.h"
#import "AudioManager.h"

@implementation SubBossLader
+(SubBossLader*)cons_pt:(CGPoint)pt {
	return [[SubBossLader node] cons_at:pt];
}

-(id)cons_at:(CGPoint)pos {
    [self setPosition:pos];
    self.active = NO;
    return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    if (!self.active && player.position.x > position_.x) {
        active = YES;
        //[GEventDispatcher push_event:[[GEvent cons_type:GEventType_BOSS1_ACTIVATE] add_pt:player.position]];
        
		NSLog(@"add boss2");
		
		if ([AudioManager get_cur_group] != BGM_GROUP_BOSS1) {
			[AudioManager playbgm_imm:BGM_GROUP_BOSS1];
		}
    }
}

-(void)reset {
    [super reset];
    self.active = NO;
}

@end
