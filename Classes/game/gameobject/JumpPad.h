#import "GameObject.h"
#import "JumpPadParticle.h"
#import "FileCache.h"

@interface JumpPad : GameObject {
    id anim;
    Vec3D normal_vec;
    int recharge_ct;
    BOOL activated;
}

+(JumpPad*)cons_x:(float)x y:(float)y dirvec:(Vec3D)vec;

@end
