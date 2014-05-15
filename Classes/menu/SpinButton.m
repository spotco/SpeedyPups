#import "SpinButton.h"
#import "UICommon.h"

@implementation SpinButton {
	BOOL started_on;
	BOOL locked;
	CCLabelTTF *time_disp;
	CCLabelTTF *cost_disp;
}

+(SpinButton*)cons_pt:(CGPoint)pos cb:(CallBack*)cb {
	return [[SpinButton node] cons_pt:pos cb:cb];
}

-(id)cons_pt:(CGPoint)pos cb:(CallBack*)cb {
	[super cons_pt:pos
			   tex:[Resource get_tex:TEX_UI_INGAMEUI_SS]
		   texrect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spinbutton"]
				cb:cb];
	
	time_disp = [Common cons_label_pos:[Common pct_of_obj:self pctx:0.6 pcty:0.575]
								 color:ccc3(200,30,30)
							  fontsize:18
								   str:@"0:00:00"];
	[self addChild:time_disp];
	
	cost_disp = [Common cons_label_pos:CGPointZero
								 color:ccc3(200,30,30)
							  fontsize:20
								   str:@"99999"];
	[self addChild:cost_disp];
	
	[self setScale:0.8];
	
	[self update_image];
	return self;
}

-(void)update_time_remaining:(int)time {
	if (time <= 0) {
		
	}
	[time_disp setString:[UICommon parse_gameengine_time:time]];
	[self update_image];
}

-(void)start_spin {
	[Common run_callback:self.cb];
	locked = YES;
	[self update_image];
}

-(void)update_image {
	if (locked) {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spinbutton_locked"]];
	} else if (started_on) {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spinbutton_pressed"]];
	} else {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spinbutton"]];
	}
	
	if (locked) {
		[time_disp setVisible:YES];
		[cost_disp setVisible:NO];
	} else {
		[time_disp setVisible:NO];
		[cost_disp setVisible:YES];
		if (started_on) {
			[cost_disp setPosition:[Common pct_of_obj:self pctx:0.5 pcty:0.265]];
		} else {
			[cost_disp setPosition:[Common pct_of_obj:self pctx:0.5 pcty:0.365]];
		}
	}
}

-(void)on_touch {
	if (!self.visible || locked) return;
	started_on = YES;
	[self update_image];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible || locked) return;
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (!CGRectContainsPoint(hitrect, pt)) {
		started_on = NO;
	} else {
		started_on = YES;
	}
	[self update_image];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible || locked) return;
	
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (started_on && CGRectContainsPoint(hitrect, pt)) {
		[self start_spin];
	}
	started_on = NO;
	[self update_image];
}

-(CGRect)hit_rect_local {
	float sto_sc = [self scale];
	[self setScale:1];
	CGRect hitrect = [self boundingBox];
	hitrect.origin = CGPointZero;
	[self setScale:sto_sc];
	return hitrect;
}


@end
