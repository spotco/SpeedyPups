#import "NMenuCharSelectPage.h"
#import "MenuCommon.h"
#import "Player.h"

@implementation NMenuCharSelectPage

static NSMutableArray* _anim_table;

+(void)initialize {
    _anim_table = [NSMutableArray arrayWithObjects:
                   @"",TEX_DOG_RUN_1,TEX_DOG_RUN_2,TEX_DOG_RUN_3,TEX_DOG_RUN_4,TEX_DOG_RUN_5,TEX_DOG_RUN_6,TEX_DOG_RUN_7, nil];
}

+(NMenuCharSelectPage*)cons {
    return [NMenuCharSelectPage node];
}

-(CCAction*)cons_anim:(NSString*)tar {
    NSArray* frames = @[@"sit_0",@"sit_1",@"sit_2",@"sit_0",@"sit_1",@"sit_2",@"sit_0",@"sit_1",@"sit_2",@"sit_0",@"sit_1_blink",@"sit_2"];
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* i in frames) {
        [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:i]]];
    }
    return [Common make_anim_frames:animFrames speed:0.2];
}

-(void)dog_spr_anim {
    [dog_spr stopAllActions];
    [dog_spr runAction:[self cons_anim:[_anim_table objectAtIndex:cur_dog]]];
}

-(id)init {
    self = [super init];
    [GEventDispatcher add_listener:self];
    
    cur_dog = 1;
    
    dog_spr = [CCSprite node];
    [self dog_spr_anim];
    [dog_spr setPosition:[Common screen_pctwid:0.5 pcthei:0.35]];
    [self addChild:dog_spr];
    
    CCMenuItem *leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_left" tar:self sel:@selector(arrow_left) pos:[Common screen_pctwid:0.3 pcthei:0.35]];
    CCMenuItem *rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_arrow_right" tar:self sel:@selector(arrow_right) pos:[Common screen_pctwid:0.7 pcthei:0.35]];
    CCMenuItem *select = [MenuCommon item_from:TEX_NMENU_ITEMS rect:@"nmenu_checkbutton" tar:self sel:@selector(select_char) pos:[Common screen_pctwid:0.72 pcthei:0.575]];
    controlm = [CCMenu menuWithItems:leftarrow,rightarrow,select, nil];
    [controlm setPosition:ccp(0,0)];
    [self addChild:controlm z:1];
    
    spotlight = [MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_spotlight" pos:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:spotlight];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_curtains" pos:[Common screen_pctwid:0.5 pcthei:0.95]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_charselmenu" pos:[Common screen_pctwid:0.5 pcthei:0.75]]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    infodesc = [CCLabelTTF labelWithString:@""
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:15];
    [infodesc setColor:ccc3(0,0,0)];
    [infodesc setAnchorPoint:ccp(0,1)];
    [infodesc setPosition:[Common screen_pctwid:0.32 pcthei:0.81]];
    [self addChild:infodesc];
    
    for(int i = 0; i < [_anim_table count]; i++) {
        if ([_anim_table[i] isEqualToString:[Player get_character]]) {
            cur_dog = i;
            break;
        }
    }
    [self refresh];
    
    return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [controlm setVisible:NO];
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        [controlm setVisible:YES];
        
    }
}

-(void)refresh {
    [self dog_spr_anim];
    if ([((NSString*)[_anim_table objectAtIndex:cur_dog]) isEqualToString:[Player get_character]]) {
        [spotlight setVisible:YES];
    } else {
        [spotlight setVisible:NO];
    }
    [infodesc setString:[NSString stringWithFormat:@"Current:%@\nSelected:%@",_anim_table[cur_dog],[Player get_character]]];
}

-(void)select_char {
    [Player set_character:_anim_table[cur_dog]];
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_CHANGE_CURRENT_DOG]];
    [self refresh];
}

-(void)arrow_left {
    cur_dog--;
    if (cur_dog <= 0) {
        cur_dog = [_anim_table count]-1;
    }
    [self refresh];
}

-(void)arrow_right {
    cur_dog++;
    if (cur_dog >= [_anim_table count]) {
        cur_dog = 1;
    }
    [self refresh];
}

@end
