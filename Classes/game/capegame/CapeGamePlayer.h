#import "CCSprite.h"
#import "Common.h"

@interface CapeGamePlayer : CCSprite {
	CCAction *_anim_cape, *_anim_stand, *_anim_rocket, *_anim_hit;
	CCAction *cur_anim;
}

+(CapeGamePlayer*)cons;
-(void)do_cape_anim;
-(void)do_stand;
-(void)do_hit;
-(void)do_rocket;
-(BOOL)is_rocket;

-(void)set_rotation;

-(HitRect)get_hitrect;

@property(readwrite,assign) float vx,vy;

@end
