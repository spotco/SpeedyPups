#import "ChallengeModeSelect.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"
#import "Challenge.h"

@interface ChallengeButtonIcon : CCSprite {
    CCSprite *locked,*unlocked;
}
@end

@implementation ChallengeButtonIcon

#define tcbi_sub_text 1

-(id)init {
    self = [super init];
    [self setTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]];
    [self setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"panelbutton.png"]];
    
    locked = [CCSprite node];
    [locked addChild:
     [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                            rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"lock"]
      ] pos:ccp(30,56)]
     ];
    [locked addChild:[Common cons_label_pos:ccp(55,70)
                                      color:ccc3(100, 100, 100)
                                   fontsize:25
                                        str:@"-1"] z:0 tag:tcbi_sub_text];
    [self addChild:locked];
    
    unlocked = [CCSprite node];
    [unlocked addChild:[Common cons_label_pos:ccp(40,55)
                                      color:ccc3(153, 0, 0)
                                   fontsize:45
                                        str:@"-1"] z:0 tag:tcbi_sub_text];
    [self addChild:unlocked];
    
    [locked setVisible:NO];
    [unlocked setVisible:NO];
    
    return self;
}

-(void)set_num:(int)i locked:(BOOL)l {
    [((CCLabelTTF*)[locked getChildByTag:tcbi_sub_text]) setString:[NSString stringWithFormat:@"%d",i]];
    [((CCLabelTTF*)[unlocked getChildByTag:tcbi_sub_text]) setString:[NSString stringWithFormat:@"%d",i]];
    [locked setVisible:l];
    [unlocked setVisible:!l];
}

@end

@interface ChallengeButton : CCMenuItemSprite
@property(readwrite,strong) ChallengeButtonIcon *p_a,*p_b;
@end

@implementation ChallengeButton

+(ChallengeButton*)cons_pos:(CGPoint)pos tar:(id)tar sel:(SEL)sel {
    ChallengeButtonIcon *p_a = [ChallengeButtonIcon node];
    ChallengeButtonIcon *p_b = [ChallengeButtonIcon node];
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    ChallengeButton *p = [ChallengeButton itemFromNormalSprite:p_a selectedSprite:p_b target:tar selector:sel];
    [p setPosition:pos];
    p.p_a = p_a;
    p.p_b = p_b;
    return p;
}

-(void)set_num:(int)i locked:(BOOL)l {
    [self.p_a set_num:i locked:l];
    [self.p_b set_num:i locked:l];
    [self setIsEnabled:!l];
}

@end

@implementation ChallengeModeSelect

+(ChallengeModeSelect*)cons {
    return [ChallengeModeSelect node];
}

-(id)init {
    self = [super init];
    [self setAnchorPoint:ccp(0,0)];
    [self addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.9] color:ccc3(0, 0, 0) fontsize:25 str:@"Challenge Select"] z:2];
    
    
    leftarrow = [MenuCommon item_from:TEX_NMENU_ITEMS
                                 rect:@"nmenu_arrow_left"
                                  tar:self sel:@selector(arrow_left)
                                  pos:[Common screen_pctwid:0.14 pcthei:0.5]];
    
    rightarrow = [MenuCommon item_from:TEX_NMENU_ITEMS
                                  rect:@"nmenu_arrow_right"
                                   tar:self sel:@selector(arrow_right)
                                   pos:[Common screen_pctwid:0.89 pcthei:0.5]];
    
    CCMenu *selmenu = [CCMenu menuWithItems:leftarrow,rightarrow, nil];
    [selmenu setPosition:ccp(0,0)];
    [self addChild:selmenu];
    
    panes = [[NSMutableArray alloc] init];
    
    SEL clk[] = {@selector(click0),@selector(click1),@selector(click2),@selector(click3),@selector(click4),@selector(click5),@selector(click6),@selector(click7)};
    for(int i = 0; i < 8; i++) {
        float wid = (i%4)*0.17-0.29;
        float hei = (i/4)*(-0.3)+0.02;
        [panes addObject:[ChallengeButton cons_pos:[Common screen_pctwid:wid pcthei:hei] tar:self sel:clk[i]]];
    }
    
    CCMenu *lvls = [CCMenu menuWithItems:nil];
    for (CCMenuItem *i in panes) {
        [lvls addChild:i];
    }
    [self addChild:lvls];
    [lvls setPosition:ccp(lvls.position.x+23,lvls.position.y+50)];
    
    page_offset = 0;
    [self update];
    
    return self;
}

-(void)close {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_STARTING_PAGE_ID i2:0]];
}

-(void)arrow_left {
    if (page_offset > 0) {
        page_offset-=8;
    }
    [self update];
}

-(void)arrow_right {
    if (page_offset+8<=[ChallengeRecord get_num_challenges]) {
        page_offset+=8;
    }
    [self update];
}

-(void)update {
    int max_chal = [ChallengeRecord get_num_challenges];
    int max_avail = [ChallengeRecord get_highest_available_challenge];
    
    for(int i = 0; i < 8; i++) {
        int pind = i+page_offset;
        if (pind < max_chal) {
            [(ChallengeButton*)panes[i] set_num:pind locked:pind>max_avail];
            [(ChallengeButton*)panes[i] setVisible:YES];
            
        } else {
            [(ChallengeButton*)panes[i] setVisible:NO];
        }
    }
    [leftarrow setVisible:page_offset > 0];
    [rightarrow setVisible:page_offset+8<=max_chal];
}

-(void)clicked:(int)i{
    NSLog(@"clicked on %d",page_offset+i);
}

-(void)click0 {[self clicked:0];}
-(void)click1 {[self clicked:1];}
-(void)click2 {[self clicked:2];}
-(void)click3 {[self clicked:3];}
-(void)click4 {[self clicked:4];}
-(void)click5 {[self clicked:5];}
-(void)click6 {[self clicked:6];}
-(void)click7 {[self clicked:7];}



@end
