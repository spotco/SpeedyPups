#import "CCSprite.h"

@interface CapeGamePlayer : CCSprite

+(CapeGamePlayer*)cons;
-(void)do_cape_anim;
-(void)do_stand;

-(void)set_rotation;

@property(readwrite,assign) float vx,vy;

@end
