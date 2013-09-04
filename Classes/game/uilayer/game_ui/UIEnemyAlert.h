#import "CCSprite.h"
#import "Vec3D.h"

@interface UIEnemyAlert : CCSprite {
	CCSprite *mainbody, *arrow;
}

+(UIEnemyAlert*)cons;
-(void)set_flash:(BOOL)v;
-(void)set_dir:(Vec3D)dir;

@end
