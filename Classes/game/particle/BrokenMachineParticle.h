#import "BreakableWallRockParticle.h"

@interface BrokenMachineParticle : BreakableWallRockParticle
+(BrokenMachineParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy;
@end

@interface BrokenCopterMachineParticle : BreakableWallRockParticle
+(BrokenCopterMachineParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy pimg:(int)pimg;
@end