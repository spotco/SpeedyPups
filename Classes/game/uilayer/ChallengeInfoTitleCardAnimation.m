#import "ChallengeInfoTitleCardAnimation.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineLayer.h"

#define DEFAULT_TRANS_LEN 20
#define DEFAULT_STAY_LEN 175
#define XPOS 0.5
#define DEFAULT_YPOS_START 1.3
#define DEFAULT_YPOS_END 0.875

@implementation TutorialInfoTitleCardAnimation
+(TutorialInfoTitleCardAnimation*)cons_g:(GameEngineLayer *)g msg:(NSString *)msg {
	return [[[TutorialInfoTitleCardAnimation alloc] init] cons_g:g msg:msg];
}
-(id)cons_g:(GameEngineLayer *)g msg:(NSString *)tmsg {
	self.TRANS_LEN = DEFAULT_TRANS_LEN;
	self.STAY_LEN = DEFAULT_STAY_LEN*1.4;
	self.YPOS_START = -0.3;
	self.YPOS_END = 0.125;
	
	msg = tmsg;
	base = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
								  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeintrocard"]];
	[base setPosition:[Common screen_pctwid:XPOS pcthei:self.YPOS_START]];
	[self addChild:base];
	ct = 1;
	mode = TitleCardMode_DOWN;
	animct = self.TRANS_LEN;
	
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:18]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    CCLabelTTF *infodesc = [CCLabelTTF labelWithString:msg
                                dimensions:actualSize
                                 alignment:UITextAlignmentCenter
                                  fontName:@"Carton Six"
                                  fontSize:18];
    [infodesc setColor:ccc3(20,20,20)];
	[infodesc setAnchorPoint:ccp(0.5,1)];
    [infodesc setPosition:[Common pct_of_obj:base pctx:0.5 pcty:0.825]];
	[base addChild:infodesc];
	
	return self;
}
@end

@implementation FreerunInfoTitleCardAnimation
+(FreerunInfoTitleCardAnimation*)cons_g:(GameEngineLayer*)g {
	return [[[FreerunInfoTitleCardAnimation alloc] init] cons_g:g];
}
-(id)cons_g:(GameEngineLayer*)g {
	self.TRANS_LEN = DEFAULT_TRANS_LEN;
	self.STAY_LEN = DEFAULT_STAY_LEN;
	self.YPOS_START = DEFAULT_YPOS_START;
	self.YPOS_END = DEFAULT_YPOS_END;
	
	base = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
								  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeintrocard"]];
	[base setPosition:[Common screen_pctwid:XPOS pcthei:self.YPOS_START]];
	[self addChild:base];
	ct = 1;
	mode = TitleCardMode_DOWN;
	animct = self.TRANS_LEN;
	
	CCLabelTTF *tittle = [Common cons_label_pos:[Common pct_of_obj:base pctx:0.5 pcty:0.67]
										  color:ccc3(20,20,20)
									   fontsize:29
											str:@"Freerun Mode"];
	[tittle setAnchorPoint:ccp(0.5,0.5)];
	[base addChild:tittle];
	[base addChild:[Common cons_label_pos:[Common pct_of_obj:base pctx:0.5 pcty:0.28]
									color:ccc3(20,20,20)
								 fontsize:12
									  str:@"Let's see how far you can go!"]];
	return self;
}
@end

@implementation ChallengeInfoTitleCardAnimation
@synthesize TRANS_LEN,STAY_LEN;
@synthesize YPOS_START,YPOS_END;
+(ChallengeInfoTitleCardAnimation*)cons_g:(GameEngineLayer*)g {
	return [[[ChallengeInfoTitleCardAnimation alloc] init] cons_g:g];
}

-(id)cons_g:(GameEngineLayer*)g {
	TRANS_LEN = DEFAULT_TRANS_LEN;
	STAY_LEN = DEFAULT_STAY_LEN;
	YPOS_START = DEFAULT_YPOS_START;
	YPOS_END = DEFAULT_YPOS_END;
	
	ChallengeInfo *info = g.get_challenge;
	base = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
											rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeintrocard"]];
	[base setPosition:[Common screen_pctwid:XPOS pcthei:YPOS_START]];
	[self addChild:base];
	ct = 1;
	mode = TitleCardMode_DOWN;
	animct = TRANS_LEN;
	if (g.get_challenge == NULL) { NSLog(@"null challenge"); return self; }
	
	CCLabelTTF *tittle = [Common cons_label_pos:[Common pct_of_obj:base pctx:0.31 pcty:0.67]
										  color:ccc3(20,20,20)
									   fontsize:29
											str:strf("Challenge %d",[ChallengeRecord get_number_for_challenge:info])];
	[tittle setAnchorPoint:ccp(0,0.5)];
	[base addChild:tittle];
	[base addChild:[Common cons_label_pos:[Common pct_of_obj:base pctx:0.5 pcty:0.28]
									color:ccc3(20,20,20)
								 fontsize:12
									  str:[info to_string]]];
	
	TexRect *tr = [ChallengeRecord get_for:info.type];
	[base addChild:[[CCSprite spriteWithTexture:tr.tex
										   rect:tr.rect]
					pos:[Common pct_of_obj:base
									  pctx:0.2
									  pcty:0.65]]];
	
	return self;
}

-(void)update {
	if (mode == TitleCardMode_DOWN) {
		[base setPosition:[Common screen_pctwid:XPOS
										 pcthei:YPOS_END + (((float)animct) / TRANS_LEN)*(YPOS_START-YPOS_END)
						   ]];
		animct--;
		if (animct == 0) {
			mode = TitleCardMode_STAY;
			animct = STAY_LEN;
		}
		
	} else if (mode == TitleCardMode_STAY) {
		[base setPosition:[Common screen_pctwid:XPOS pcthei:YPOS_END]];
		animct--;
		if (animct == 0) {
			mode = TitleCardMode_UP;
			animct = TRANS_LEN;
		}
		
	} else {
		[base setPosition:[Common screen_pctwid:XPOS
										 pcthei:YPOS_END + ((1-((float)animct) / TRANS_LEN)) * (YPOS_START-YPOS_END)
						   ]];
		animct--;
		if (animct == 0) {
			ct = 0;
		}
	}
	if (ct==0) {
		[[self parent] removeChild:self cleanup:NO];
	}
}
@end
