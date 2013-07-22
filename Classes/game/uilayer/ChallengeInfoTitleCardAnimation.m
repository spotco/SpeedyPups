#import "ChallengeInfoTitleCardAnimation.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineLayer.h"

@implementation ChallengeInfoTitleCardAnimation

+(ChallengeInfoTitleCardAnimation*)cons_g:(GameEngineLayer*)g {
	return [[[ChallengeInfoTitleCardAnimation alloc] init] cons_g:g];
}

#define TRANS_LEN 20
#define STAY_LEN 175
#define XPOS 0.5
#define YPOS_START 1.3
#define YPOS_END 0.875

-(id)cons_g:(GameEngineLayer*)g {
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
