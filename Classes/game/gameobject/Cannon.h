#import "GameObject.h"

@interface Cannon : GameObject {
	BOOL player_loaded;
	float deactivate_ct;
}

@property(readwrite,assign) CGPoint dir;

+(Cannon*)cons_pt:(CGPoint)pos dir:(CGPoint)dir;

-(BOOL)cannon_show_head:(Player*)p;
-(void)detach_player;
-(CGPoint)get_nozzel_position;
-(void)deactivate_for:(int)time;

@end
