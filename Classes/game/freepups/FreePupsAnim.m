#import "FreePupsAnim.h"
#import "Lab1BGLayerSet.h"
#import "Lab2BGLayerSet.h"
#import "Lab3BGLayerSet.h" 
#import "LabLineIsland.h"
#import "RepeatFillSprite.h"
#import "LabHandRail.h"
#import "AudioManager.h"
#import "FreeRunStartAtUnlockUIAnimation.h"

@interface CCSprite_WithVel : CCSprite
@property(readwrite,assign) float vx,vy,vr;
@end
@implementation CCSprite_WithVel
@synthesize vx,vy,vr;
@end

@implementation FreePupsAnim

+(CCScene*)scene_with:(LabNum)labnum {
	CCScene *rtv = [CCScene node];
	[rtv addChild:[[FreePupsAnim node] cons_with:labnum]];
	return rtv;
}

static float GROUNDLEVEL;

-(id)cons_with:(LabNum)labnum {
	[self cons_anim];
	if (labnum == LabNum_1) {
		BGLayerSet *set = [Lab1BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
	
	} else if (labnum == LabNum_2) {
		BGLayerSet *set = [Lab2BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
		
	} else if (labnum == LabNum_3) {
		BGLayerSet *set = [Lab3BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
		
	}
	
	CCSprite *ground = [RepeatFillSprite cons_tex:[Resource get_tex:TEX_INTRO_ANIM_SS]
											 rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_lab_groundtex"]
											  rep:6];
	[ground setScale:0.5];
	[self addChild:ground];
	
	GROUNDLEVEL = [FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_lab_groundtex"].size.height*0.5 - 6;
	
	LabHandRail *rail = [LabHandRail cons_pt1:ccp(0,0) pt2:ccp([Common SCREEN].width*2,0)];
	[rail setPosition:ccp(0,GROUNDLEVEL)];
	rail.do_render = YES;
	[rail setScale:0.7];
	[self addChild:rail z:2];
	
	CGPoint cage_start = [Common screen_pctwid:0.65 pcthei:0.7];

	CCSprite *cage_chain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_chain"]];
	[cage_chain setScale:0.7];
	[cage_chain setAnchorPoint:ccp(0.5,0)];
	[cage_chain setPosition:ccp(cage_start.x,cage_start.y+20)];
	[self addChild:cage_chain];
	
	
	cage_base = [CCSprite_WithVel node];
	[cage_base setPosition:cage_start];
	[cage_base setScale:0.7];
	[self addChild:cage_base];
	
	cage_bottom = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_open_bottom"]];
	[cage_base addChild:cage_bottom];
	cage_top = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_open_top"]];
	[cage_top setPosition:ccp(0,55)];
	[cage_base addChild:cage_top];
	
	dog = [CCSprite_WithVel node];
	[dog runAction:run_anim];
	[dog setAnchorPoint:ccp(0.5,0)];
	[dog setScale:0.7];
	[dog setPosition:ccp(-75,GROUNDLEVEL)];
	[self addChild:dog];
	
	mode = FreePupsAnimMode_RUNIN;
	cage_on_ground = NO;
	pups = [NSMutableArray array];
	[Common unset_dt];
	
	uianim = [FreePupsUIAnimation cons];
	[self addChild:uianim z:4];
	
	[self schedule:@selector(update:)];
	return self;
}

-(void)update:(ccTime)dt {
	[Common set_dt:dt];
	[uianim update];
	
	if (mode == FreePupsAnimMode_RUNIN) {
		[dog setPosition:CGPointAdd(dog.position, ccp(3*[Common get_dt_Scale],0))];
		
		if (dog.position.x > [Common SCREEN].width*0.35) {
			mode = FreePupsAnimMode_ROLL;
			[dog stopAllActions];
			[dog runAction:roll_anim];
			[AudioManager playsfx:SFX_SPIN];
		}
		
	} else if (mode == FreePupsAnimMode_ROLL) {
		CGPoint target_pt = CGPointAdd(cage_base.position, ccp(-40,-35));
		Vec3D dir_v = [VecLib scale:[VecLib normalize:[VecLib cons_x:target_pt.x-dog.position.x y:target_pt.y-dog.position.y z:0]] by:6*[Common get_dt_Scale]];
		[dog setPosition:CGPointAdd(dog.position, ccp(dir_v.x,dir_v.y))];
		
		if (dog.position.x >= target_pt.x) {
			mode = FreePupsAnimMode_BREAKANDFALL;
			dog.vx = -4.5;
			dog.vy = 7;
			[AudioManager playsfx:SFX_ROCKBREAK];
		}
		
	} else if (mode == FreePupsAnimMode_BREAKANDFALL) {
		[dog setPosition:CGPointAdd(dog.position, ccp(dog.vx*[Common get_dt_Scale],dog.vy*[Common get_dt_Scale]))];
		if (dog.vx < 0) {
			dog.vy -= 0.3 * [Common get_dt_Scale];
			if (dog.position.y <= GROUNDLEVEL) {
				dog.vx = 4;
				dog.vy = 0;
				[dog setPosition:ccp(dog.position.x,GROUNDLEVEL)];
				[dog stopAllActions];
				[dog runAction:run_anim];
			}
		} else {
			if (dog.position.x > [Common SCREEN].width+100) {
				[self exit];
			}
		}
		
		if (!cage_on_ground) {
			[cage_base setPosition:CGPointAdd(cage_base.position, ccp(0,-7*[Common get_dt_Scale]))];
			float cage_groundlevel = GROUNDLEVEL + cage_bottom.boundingBoxInPixels.size.height * 0.5 * 0.7 - 10;
			if (cage_base.position.y <= cage_groundlevel) {
				cage_on_ground = YES;
				[cage_base setPosition:ccp(cage_base.position.x,cage_groundlevel)];
				cage_top.vx = 3;
				cage_top.vy = 6;
				[AudioManager playsfx:SFX_BOP];
				[cage_bottom setTextureRect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_empty_back"]];
				[self reorderChild:cage_base z:1];
				for (int i = 0; i < 8; i++) {
					CCSprite_WithVel *pup = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
																		   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:i%2==0?@"pupcage_pup_0":@"pupcage_pup_1"]];
					[pup setPosition:ccp(float_random(-20, 20),float_random(-10, 10))];
					pup.vx = float_random(1, 6) * (i<4?-1:1);
					pup.vy = float_random(3, 13);
					pup.vr = float_random(-10, 10);
					[pups addObject:pup];
					[cage_base addChild:pup];
				}
				[AudioManager playsfx:SFX_BARK_HIGH];
				[AudioManager playsfx:SFX_FANFARE_WIN];
				
				[cage_base addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
														   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_empty_bars"]]];
				
			}
			
		} else {
			[cage_top setPosition:CGPointAdd(cage_top.position, ccp(cage_top.vx*[Common get_dt_Scale],cage_top.vy*[Common get_dt_Scale]))];
			[cage_top setRotation:cage_top.rotation+10*[Common get_dt_Scale]];
			cage_top.vy -= 0.3 * [Common get_dt_Scale];
			
			for (CCSprite_WithVel *pup in pups) {
				[pup setPosition:CGPointAdd(pup.position, ccp(pup.vx*[Common get_dt_Scale],pup.vy*[Common get_dt_Scale]))];
				[pup setRotation:pup.rotation+pup.vr*[Common get_dt_Scale]];
				pup.vy -= 0.3 * [Common get_dt_Scale];
			}
		}
		
	}
}

-(void)exit {
	[self unscheduleAllSelectors];
	[self removeAllChildrenWithCleanup:YES];
	[[CCDirector sharedDirector] popScene];
}

-(void)cons_anim {
	run_anim = [Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"] speed:0.1 tex_key:[Player get_character]];
	roll_anim = [Common cons_anim:@[@"roll_0",@"roll_1",@"roll_2",@"roll_3"] speed:0.05 tex_key:[Player get_character]];
}

@end
