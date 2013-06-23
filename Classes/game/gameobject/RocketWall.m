#import "RocketWall.h"
#import "GameEngineLayer.h"
#import "LauncherRocket.h"

@implementation RocketWall

+(RocketWall*)cons_x:(float)x y:(float)y width:(float)width height:(float)height {
    RocketWall *w = [RocketWall node];
    [w cons_x:x y:y width:width height:height];
    return w;
    
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    if (player.position.x > position_.x) {
        return;
    }
    NSMutableArray *to_remove = [NSMutableArray array];
    for (GameObject *o in g.game_objects) {
        if ([[o class] isSubclassOfClass:[LauncherRocket class]] && [Common hitrect_touch:[self get_hit_rect] b:[o get_hit_rect]]) {
            [to_remove addObject:o];
        }
    }
    for (GameObject *o in to_remove) {
        [g remove_gameobject:o];
    }
    [to_remove removeAllObjects];
}

@end
