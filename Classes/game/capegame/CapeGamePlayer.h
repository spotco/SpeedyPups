#import "CCSprite.h"
#import "Common.h"

@interface CapeGamePlayer : CCSprite

+(CapeGamePlayer*)cons;
-(void)do_cape_anim;
-(void)do_stand;
-(void)do_hit;

-(void)set_rotation;

-(HitRect)get_hitrect;

@property(readwrite,assign) float vx,vy;

@end
