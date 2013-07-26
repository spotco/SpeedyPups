#import "FreeRunProgressAnimation.h"
#import "Resource.h"
#import "FileCache.h"

@implementation FreeRunProgressAnimation

#define DEFAULT_TRANS_LEN 20
#define DEFAULT_STAY_LEN 175
#define XPOS 0.5
#define DEFAULT_YPOS_START 1.3
#define DEFAULT_YPOS_END 0.875

+(FreeRunProgressAnimation*)cons_at:(FreeRunProgress)pos {
	return [[FreeRunProgressAnimation node] cons_at:pos];
}

-(CCSprite*)make_xout {
	return [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"progresspanelx"]];
}

-(id)cons_at:(FreeRunProgress)pos {
	self.TRANS_LEN = DEFAULT_TRANS_LEN;
	self.STAY_LEN = DEFAULT_STAY_LEN;
	self.YPOS_START = DEFAULT_YPOS_START;
	self.YPOS_END = DEFAULT_YPOS_END;
	base = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
								  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"progresspanel"]];
	[base setPosition:[Common screen_pctwid:XPOS pcthei:self.YPOS_START]];
	[self addChild:base];
	
	ct = 1;
	mode = TitleCardMode_DOWN;
	animct = self.TRANS_LEN;
	
	[base addChild:[Common cons_label_pos:[Common pct_of_obj:base pctx:0.5 pcty:0.8]
									color:ccc3(0,0,0)
									fontsize:18
									str:@"Progress"]];
	
	panelmarker = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"progresspanelmarker"]];
	[base addChild:panelmarker];
	float markery = 0.5;
	
	if (pos == FreeRunProgress_PRE_1) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.125 pcty:markery]];
	if (pos == FreeRunProgress_1) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.25 pcty:markery]];
	if (pos == FreeRunProgress_PRE_2) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.375 pcty:markery]];
	if (pos == FreeRunProgress_2) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.5 pcty:markery]];
	if (pos == FreeRunProgress_PRE_3) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.625 pcty:markery]];
	if (pos == FreeRunProgress_3) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.75 pcty:markery]];
	if (pos == FreeRunProgress_POST_3) [panelmarker setPosition:[Common pct_of_obj:base pctx:0.875 pcty:markery]];
	
	if (pos > FreeRunProgress_1) [base addChild:[[self make_xout] pos:[Common pct_of_obj:base pctx:0.25 pcty:0.24]]];
	if (pos > FreeRunProgress_2) [base addChild:[[self make_xout] pos:[Common pct_of_obj:base pctx:0.5 pcty:0.24]]];
	if (pos > FreeRunProgress_3) [base addChild:[[self make_xout] pos:[Common pct_of_obj:base pctx:0.75 pcty:0.24]]];
	return self;
}

-(void)update {
	flashct++;
	if (panelmarker.visible) {
		if (flashct>=40) {
			[panelmarker setVisible:!panelmarker.visible];
			flashct = 0;
		}
	} else {
		if (flashct>=10) {
			[panelmarker setVisible:!panelmarker.visible];
			flashct = 0;
		}
	}
	[super update];
}


@end
