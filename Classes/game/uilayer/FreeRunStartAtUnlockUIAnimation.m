#import "FreeRunStartAtUnlockUIAnimation.h"
#import "Resource.h"
#import "FileCache.h"
#import "FreeRunStartAtManager.h"

#define DEFAULT_TRANS_LEN 20
#define DEFAULT_STAY_LEN 175
#define XPOS 0.5

@implementation FreeRunStartAtUnlockUIAnimation
+(FreeRunStartAtUnlockUIAnimation*)cons_for_unlocking:(FreeRunStartAt)startat {
	return [[[FreeRunStartAtUnlockUIAnimation alloc] init] cons_for_unlocking:startat];
}
-(id)cons_for_unlocking:(FreeRunStartAt)startat {
	self.TRANS_LEN = DEFAULT_TRANS_LEN;
	self.STAY_LEN = DEFAULT_STAY_LEN;
	self.YPOS_START = -0.3;
	self.YPOS_END = 0.125;
	
	base = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
								  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeintrocard"]];
	[base setPosition:[Common screen_pctwid:XPOS pcthei:self.YPOS_START]];
	[self addChild:base];
	
	CCLabelTTF *text_disp = [[Common cons_label_pos:[Common pct_of_obj:base pctx:0.2 pcty:0.5]
											 color:ccc3(0,0,0)
										  fontsize:16
											   str:[NSString stringWithFormat:@"Unlocked: %@!",[FreeRunStartAtManager name_for_loc:startat]]]
							 anchor_pt:ccp(0,0.5)];
	[base addChild:text_disp];
	TexRect *tr = [FreeRunStartAtManager get_icon_for_loc:startat];
	CGPoint iconpt = text_disp.position;
	iconpt.x += text_disp.boundingBox.size.width + tr.rect.size.width * 0.8;
	
	
	[base addChild:[[CCSprite spriteWithTexture:tr.tex rect:tr.rect] pos:iconpt]];
	
	
	ct = 1;
	mode = TitleCardMode_DOWN;
	animct = self.TRANS_LEN;
	
	return self;
}
@end
