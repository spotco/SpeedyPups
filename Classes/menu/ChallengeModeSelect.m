#import "ChallengeModeSelect.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"
#import "Challenge.h"
#import "GameMain.h" 

@interface ChallengeButtonIcon : CCSprite {
    CCSprite *locked,*unlocked,*status_star,*disp_type_icon;
}
@end

@implementation ChallengeButtonIcon

#define tcbi_sub_text 1

-(id)init {
    self = [super init];
    [self setTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]];
    [self setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"panelbutton"]];
    
    locked = [CCSprite node];
    [locked addChild:
     [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                            rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"lock"]
      ] pos:ccp(30,46)]
     ];
    [locked addChild:[Common cons_label_pos:ccp(55,60)
                                      color:ccc3(100, 100, 100)
                                   fontsize:25
                                        str:@"-1"] z:0 tag:tcbi_sub_text];
    [self addChild:locked];
    
    unlocked = [CCSprite node];
    [unlocked addChild:[Common cons_label_pos:ccp(55,60)
                                      color:ccc3(153, 0, 0)
                                   fontsize:34
                                        str:@"-1"] z:0 tag:tcbi_sub_text];
    [self addChild:unlocked];
	
	disp_type_icon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
											rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeicon_coin"]];
	[disp_type_icon setPosition:ccp(30,60)];
	[self addChild:disp_type_icon];
    
    status_star = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                                          rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"levelstar_hr"]]
                   pos:[Common pct_of_obj:self pctx:0.53 pcty:0.27]];
    [self addChild:status_star];
    
    [locked setVisible:NO];
    [unlocked setVisible:NO];
    
    return self;
}

-(void)set_num:(int)i locked:(BOOL)l {
    [((CCLabelTTF*)[locked getChildByTag:tcbi_sub_text]) setString:[NSString stringWithFormat:@"%d",i+1]];
    [((CCLabelTTF*)[unlocked getChildByTag:tcbi_sub_text]) setString:[NSString stringWithFormat:@"%d",i+1]];
    [locked setVisible:l];
    [unlocked setVisible:!l];
    if (l) {
        [status_star setVisible:NO];
		[disp_type_icon setVisible:NO];
    } else {
        [status_star setVisible:YES];
        [status_star setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ
															  idname:[ChallengeRecord get_beaten_challenge:i]?@"levelstar_hr":@"levelstar_locked_hr"]];
		[disp_type_icon setVisible:YES];
		TexRect *tr = [ChallengeRecord get_for:[ChallengeRecord get_challenge_number:i].type];
		[disp_type_icon setTexture:tr.tex];
		[disp_type_icon setTextureRect:tr.rect];
	}
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
    pagewindow = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                                         rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeselectwindow"]]
                  pos:[Common screen_pctwid:0.5 pcthei:0.525]];
    [self addChild:pagewindow];
    
    CGRect windowsize = [FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"challengeselectwindow"];
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                               rect:@"nmenu_closebutton"
                                                tar:self sel:@selector(close)
                                                pos:ccp(windowsize.size.width*0.955,windowsize.size.height*0.96)];
    CCMenu *m = [CCMenu menuWithItems:closebutton, nil];
    [m setPosition:CGPointZero];
    [pagewindow addChild:m];
    
    [pagewindow setVisible:YES];
    
    
    [self cons_selectmenu];
    [self cons_chosenmenu];
    
    [chosenmenu setVisible:NO];
    [selectmenu setVisible:YES];
    
    page_offset = 0;
    [self update_selectmenu];
    
    return self;
}

-(void)cons_selectmenu {
    selectmenu = [CCSprite node];
    [pagewindow addChild:selectmenu];
	leftarrow = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
                                 rect:@"challengeselectnextarrow"
                                  tar:self sel:@selector(arrow_left)
                                  pos:[Common pct_of_obj:pagewindow pctx:0.025 pcty:0.5]];
	[leftarrow setScaleX:-1];
    
    rightarrow = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
                                  rect:@"challengeselectnextarrow"
                                   tar:self sel:@selector(arrow_right)
                                   pos:[Common pct_of_obj:pagewindow pctx:0.975 pcty:0.5]];
    
    CCMenu *selmenu = [CCMenu menuWithItems:leftarrow,rightarrow, nil];
    [selmenu setPosition:ccp(0,0)];
    [selectmenu addChild:selmenu];
    
    panes = [[NSMutableArray alloc] init];
    
    SEL clk[] = {@selector(click0),@selector(click1),@selector(click2),@selector(click3),@selector(click4),@selector(click5),@selector(click6),@selector(click7)};
    for(int i = 0; i < 8; i++) {
        float wid = (i%4)*0.2+0.2;
        float hei = -(i/4)*0.4+0.7;
        [panes addObject:[ChallengeButton cons_pos:[Common pct_of_obj:pagewindow pctx:wid pcty:hei]
											   tar:self
											   sel:clk[i]]];
    }
    
    CCMenu *lvls = [CCMenu menuWithItems:nil];
    for (CCMenuItem *i in panes) {
        [lvls addChild:i];
    }
	[lvls setPosition:CGPointZero];
    [selectmenu addChild:lvls];
	
	CCSprite *titlebarback = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
													rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ
																				   idname:@"challengeselecttitlebar"]];
	[titlebarback setPosition:[Common pct_of_obj:pagewindow pctx:0.5 pcty:0.985]];
	[pagewindow addChild:titlebarback];
	
	[titlebarback addChild:[Common cons_label_pos:[Common pct_of_obj:titlebarback pctx:0.5 pcty:0.5]
											color:ccc3(0,0,0)
										 fontsize:20
											  str:@"Challenge Select"]];
}

-(void)cons_chosenmenu {
    chosenmenu = [CCSprite node];
    [self addChild:chosenmenu];
    CCSprite *chosen_window = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@"leveldescriptionpanel"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.57]];
	
	float offset = 0.06;
	
	chosen_name = [Common cons_label_pos:[Common pct_of_obj:chosen_window pctx:0.8 pcty:0.775 + offset]
								   color:ccc3(200,30,30)
								fontsize:17
									 str:@""];
	[chosen_window addChild:chosen_name];
	
	chosen_mapname = [Common cons_label_pos:[Common pct_of_obj:chosen_window pctx:0.8 pcty:0.69 + offset]
									  color:ccc3(200,30,30)
								   fontsize:9 str:@""];
	[chosen_window addChild:chosen_mapname];
    
    NSString *maxstr = @"aaaaaaaaaaaaaa\naaaaaaaaaaaaaa\naaaaaaaaaaaaaa\naaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:12]
                    constrainedToSize:CGSizeMake(500, 700)
                        lineBreakMode:UILineBreakModeWordWrap];
    chosen_goal = [CCLabelTTF labelWithString:maxstr
                                   dimensions:actualSize
                                    alignment:UITextAlignmentLeft
                                     fontName:@"Carton Six"
                                     fontSize:12];
    [chosen_goal setColor:ccc3(0, 0, 0)];
    [chosen_goal setPosition:[Common pct_of_obj:chosen_window pctx:0.8 pcty:0.47 + offset]];
    [chosen_window addChild:chosen_goal];
	
	show_reward = [CCSprite node];
	[chosen_window addChild:show_reward];
	
	[show_reward addChild:[Common cons_label_pos:[Common pct_of_obj:chosen_window pctx:0.74 pcty:0.3 + offset]
											 color:ccc3(200,0,0)
										  fontsize:11 str:@"Reward:"]];
	
	reward_amount = [Common cons_label_pos:[Common pct_of_obj:chosen_window pctx:0.84 pcty:0.2 + offset]
									 color:ccc3(0,0,0)
								  fontsize:19
									   str:@"000000"];
	[show_reward addChild:reward_amount];
	
	TexRect *bones = [ChallengeRecord get_for:ChallengeType_COLLECT_BONES];
	[show_reward addChild:[[CCSprite spriteWithTexture:bones.tex rect:bones.rect] pos:[Common pct_of_obj:chosen_window pctx:0.7275 pcty:0.17 + offset]]];
    
	show_already_beaten = [CCSprite node];
	[show_already_beaten addChild:[Common cons_label_pos:[Common pct_of_obj:chosen_window pctx:0.8 pcty:0.27 + offset]
												   color:ccc3(110,110,110) fontsize:17 str:@"Completed!"]];
	[chosen_window addChild:show_already_beaten];
	
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                               rect:@"nmenu_closebutton"
                                                tar:self sel:@selector(close)
                                                pos:[Common pct_of_obj:chosen_window pctx:0.975 pcty:0.95]];
    CCMenu *m = [CCMenu menuWithItems:closebutton, nil];
    [m setPosition:CGPointZero];
	[chosen_window addChild:m];
    
    chosen_preview = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_LEVELSELOBJ]
                                             rect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:@""]]
                      pos:[Common pct_of_obj:chosen_window pctx:0.3 pcty:0.51]];
    [chosen_window addChild:chosen_preview];
    
    CCMenuItem *back = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
                                        rect:@"gobackbutton"
                                         tar:self sel:@selector(back_to_select)
                                         pos:[Common pct_of_obj:chosen_window pctx:0.05 pcty:0]];
    
    CCMenuItem *play = [MenuCommon item_from:TEX_NMENU_LEVELSELOBJ
                                        rect:@"runbutton"
                                         tar:self sel:@selector(play)
                                         pos:[Common pct_of_obj:chosen_window pctx:0.97 pcty:0]];
    
    CCMenu *but = [CCMenu menuWithItems:back,play, nil];
    [but setPosition:CGPointZero];
    [chosen_window addChild:but];
    
    [chosen_name setString:@""];
    [chosen_goal setString:@""];
    
    [chosenmenu addChild:chosen_window];
}

-(void)close {
	[AudioManager playsfx:SFX_MENU_DOWN];
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_STARTING_PAGE_ID i2:0]];
}

-(void)arrow_left {
    if (page_offset > 0) {
        page_offset-=8;
		[AudioManager playsfx:SFX_MENU_UP];
    }
    [self update_selectmenu];
}

-(void)arrow_right {
    if (page_offset+8<=[ChallengeRecord get_num_challenges]) {
        page_offset+=8;
		[AudioManager playsfx:SFX_MENU_UP];
    }
    [self update_selectmenu];
}

-(void)update_selectmenu {
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

-(void)update_chosenmenu {
    ChallengeInfo* cc = [ChallengeRecord get_challenge_number:chosen_level];
    [chosen_name setString:[NSString stringWithFormat:@"Challenge %d:",chosen_level+1]];
	[chosen_mapname setString:cc.map_name];
    [chosen_goal setString:[cc to_string]];
	[reward_amount setString:[NSString stringWithFormat:@"%d",cc.reward]];
	
	NSString *cle = @"";
	if (cc.type == ChallengeType_COLLECT_BONES) {
		cle = @"preview_collect_bones";
	} else if (cc.type == ChallengeType_FIND_SECRET) {
		cle = @"preview_find_secrets";
	} else if (cc.type == ChallengeType_TIMED) {
		cle = @"preview_timed";
	}
	[chosen_preview setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_LEVELSELOBJ idname:cle]];
	
	if ([ChallengeRecord get_beaten_challenge:chosen_level]) {
		[show_reward setVisible:NO];
		[show_already_beaten setVisible:YES];
		
	} else {
		[show_reward setVisible:YES];
		[show_already_beaten setVisible:NO];
		
	}
}

-(void)clicked:(int)i{
	[AudioManager playsfx:SFX_MENU_UP];
    [self choose_challenge:i];
}

-(void)back_to_select {
    [pagewindow setVisible:YES];
    [selectmenu setVisible:YES];
    [chosenmenu setVisible:NO];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

-(void)play {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_SELECTED_CHALLENGELEVEL]
								  add_i1:chosen_level i2:0]];
	//[GameMain start_game_challengelevel:[ChallengeRecord get_challenge_number:chosen_level]];
}

-(void)choose_challenge:(int)i {
    [pagewindow setVisible:NO];
    chosen_level = i+page_offset;
    [self update_chosenmenu];
    [selectmenu setVisible:NO];
    [chosenmenu setVisible:YES];
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
