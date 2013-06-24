#import "PhysicsEnabledObject.h"
#import "HitEffect.h"
#import "DazedParticle.h"
#import "BrokenMachineParticle.h"

@interface MinionRobot : PhysicsEnabledObject {
    BOOL busted;
    BOOL has_shadow;
}

+(MinionRobot*)cons_x:(float)x y:(float)y;
+(void)player_do_bop:(Player*)player g:(GameEngineLayer*)g;

@property(readwrite,strong) CCSprite* body;

@end
