#import "NMenuCharSelectPage.h"
#import "MenuCommon.h"
#import "Player.h"

@implementation NMenuCharSelectPage

static NSMutableArray* _anim_table;

+(NMenuCharSelectPage*)cons {
    return [NMenuCharSelectPage node];
}

-(CCAction*)cons_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_2"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_3"]]];
    return [Common make_anim_frames:animFrames speed:0.2];
}

-(void)lazy {
    if (_anim_table == NULL) {
        _anim_table = [NSMutableArray arrayWithObjects:
                   @"",TEX_DOG_RUN_1,TEX_DOG_RUN_2,TEX_DOG_RUN_3,TEX_DOG_RUN_4,TEX_DOG_RUN_5,TEX_DOG_RUN_6,TEX_DOG_RUN_7, nil];
    }
}

-(void)dog_spr_anim {
    [dog_spr stopAllActions];
    [dog_spr runAction:[self cons_anim:[_anim_table objectAtIndex:cur_dog]]];
}

-(id)init {
    [self lazy];
    self = [super init];
    
    
    cur_dog = 1;

    CCSprite *dogshadow = [CCSprite spriteWithTexture:[Resource get_tex:TEX_DOG_SHADOW]];
    [dogshadow setPosition:[Common screen_pctwid:0.49 pcthei:0.2275]];
    [dogshadow setScale:1.35];
    [dogshadow setOpacity:150];
    [self addChild:dogshadow];
    
    dog_spr = [CCSprite node];
    [self dog_spr_anim];
    [dog_spr setPosition:[Common screen_pctwid:0.5 pcthei:0.32]];
    [self addChild:dog_spr];
    
    CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_left" tar:self sel:@selector(arrow_left) pos:[Common screen_pctwid:0.3 pcthei:0.35]];
    CCMenuItem *rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_right" tar:self sel:@selector(arrow_right) pos:[Common screen_pctwid:0.7 pcthei:0.35]];
    CCMenu *m = [CCMenu menuWithItems:leftarrow,rightarrow, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    
    spotlight = [MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_spotlight" pos:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:spotlight];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_curtains" pos:[Common screen_pctwid:0.5 pcthei:0.95]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_charselmenu" pos:[Common screen_pctwid:0.5 pcthei:0.75]]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    
    return self;
}

-(void)arrow_left {
    cur_dog--;
    if (cur_dog <= 0) {
        cur_dog = [_anim_table count]-1;
    }
    [self dog_spr_anim];
    if ([((NSString*)[_anim_table objectAtIndex:cur_dog]) isEqualToString:[Player get_character]]) {
        [spotlight setVisible:YES];
    } else {
        [spotlight setVisible:NO];
    }
}

-(void)arrow_right {
    cur_dog++;
    if (cur_dog >= [_anim_table count]) {
        cur_dog = 1;
    }
    [self dog_spr_anim];
    if ([((NSString*)[_anim_table objectAtIndex:cur_dog]) isEqualToString:[Player get_character]]) {
        [spotlight setVisible:YES];
    } else {
        [spotlight setVisible:NO];
    }
}

@end
