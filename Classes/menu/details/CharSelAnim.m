#import "CharSelAnim.h"
#import "Resource.h"
#import "FileCache.h"
#import "Player.h"

@implementation CharSelAnim

+(CharSelAnim*)cons_pos:(CGPoint)pt {
    CharSelAnim* a = [CharSelAnim node];
    [a setPosition:pt];
    [GEventDispatcher add_listener:a];
    return a;
}

-(id)init {
    self = [super init];
    [self runAction:[CharSelAnim cons_run_anim:[Player get_character]]];
    [self setScale:0.65];
    return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_CHANGE_CURRENT_DOG) {
        [self stopAllActions];
        [self runAction:[CharSelAnim cons_run_anim:[Player get_character]]];
    }
}

+(CCAction*)cons_run_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_2"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_3"]]];
    return [Common make_anim_frames:animFrames speed:0.2];
}

@end
