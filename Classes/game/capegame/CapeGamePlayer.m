#import "CapeGamePlayer.h"
#import "Player.h"
#import "Common.h"

@implementation CapeGamePlayer

+(CapeGamePlayer*)cons {
	return [CapeGamePlayer node];
}

-(id)init {
	self = [super init];
	[self runAction:[Common cons_anim:@[@"cape_0",@"cape_1",@"cape_2",@"cape_3"]
								  speed:0.1
								tex_key:[Player get_character]]];
	[self setScale:0.6];
	return self;
}

@end
