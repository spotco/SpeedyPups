#import "LoadingScene.h"
#import "FileCache.h"
#import "Common.h"
#import "GEventDispatcher.h"
#import "DataStore.h"
#import "AudioManager.h"
#import "MapLoader.h"
#import "DataStore.h"
#import "Resource.h"
#import "BatchDraw.h"
#import "AutoLevelState.h"
#import "GameItemCommon.h"
#import "ObjectPool.h"

@interface OrigPtCCSpr : CCSprite
@property(readwrite,assign) CGPoint origpt;
@end

@implementation OrigPtCCSpr
@end

@implementation LoadingScene

#define LOADING_ICON @"load_icon.png"
#define LOADING_IMG @"loadinganim.png"
#define LOADING_PLIST @"loadinganim"

+(LoadingScene*)cons {
	return [LoadingScene node];
}

-(id)init {
	self = [super init];
	//[self addChild:[CCLayerColor layerWithColor:ccc4(216, 166, 122, 255)]];
	
	NSString *splashtex_str;
	splashtex_str = @"Default.png";
	bg_tex = [[CCTextureCache sharedTextureCache] addImage:splashtex_str];
	CCSprite *bg = [CCSprite spriteWithTexture:bg_tex];
	[bg setPosition:[Common screen_pctwid:0.5 pcthei:0.5]];
	[bg setRotation:90];
	[bg setScaleX:[Common SCREEN].height/bg.boundingBox.size.height];
	[bg setScaleY:[Common SCREEN].width/bg.boundingBox.size.width];
	
	[self addChild:bg];
	
	
	paw_tex = [[CCTextureCache sharedTextureCache] addImage:LOADING_ICON];
	letters_tex = [[CCTextureCache sharedTextureCache] addImage:LOADING_IMG];
	
	CGPoint wordanchor = ccp([Common SCREEN].width-190-40,[Common SCREEN].height-40);
	
	CCSprite *icon = [CCSprite spriteWithTexture:paw_tex];
	[icon setAnchorPoint:ccp(0,0)];
	[icon setPosition:CGPointAdd(wordanchor, ccp(-20,-20))];
	[self addChild:icon];
	
	loading_letters = [NSMutableArray array];
	[loading_letters addObject:[self letter:@"L" pos:CGPointAdd(ccp(55,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"O" pos:CGPointAdd(ccp(72,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"A" pos:CGPointAdd(ccp(90,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"D" pos:CGPointAdd(ccp(110,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"I" pos:CGPointAdd(ccp(124,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"N" pos:CGPointAdd(ccp(138,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"G" pos:CGPointAdd(ccp(155,0), wordanchor)]];
	[loading_letters addObject:[self letter:@"dot" pos:CGPointAdd(ccp(169,-10), wordanchor)]];
	[loading_letters addObject:[self letter:@"dot" pos:CGPointAdd(ccp(175,-10), wordanchor)]];
	[loading_letters addObject:[self letter:@"dot" pos:CGPointAdd(ccp(181,-10), wordanchor)]];
	
	return self;
}

-(CCSprite*)letter:(NSString*)letter pos:(CGPoint)pt {
	OrigPtCCSpr *l = [OrigPtCCSpr spriteWithTexture:letters_tex rect:[FileCache get_cgrect_from_plist:LOADING_PLIST idname:letter]];
	[l setPosition:pt];
	l.origpt = pt;
	[self addChild:l];
	return l;
}

-(void)load_with_callback:(CallBack*)cb {
	finished_loading = NO;
	on_finish = cb;
	[NSThread detachNewThreadSelector:@selector(async_load) toTarget:self withObject:NULL];
	[self schedule:@selector(update)];
}

-(void)async_load {
	[AudioManager begin_load];
	[Resource load_all];
	[FileCache precache_files];
	[ObjectPool prepool];
	for (NSString* i in [AutoLevelState get_all_levels]) {
        [MapLoader precache_map:i];
    }    
	
	finished_loading = YES;
}

-(void)update {
	if (finished_loading) {
		[AudioManager schedule_update];
		[GameItemCommon cons_after_textures_loaded];
		
		[self unschedule:@selector(update)];
		[Common run_callback:on_finish];
		[self removeAllChildrenWithCleanup:YES];
		[[CCTextureCache sharedTextureCache] removeTexture:letters_tex];
		[[CCTextureCache sharedTextureCache] removeTexture:paw_tex];
		[[CCTextureCache sharedTextureCache] removeTextureForKey:@"Default.png"];
		//[[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
		letters_tex = NULL;
		paw_tex = NULL;
		return;
	}
	anim_ct--;
	if (anim_ct <= 0) {
		if (arr_anim_i < [loading_letters count]) {
			OrigPtCCSpr *letter = loading_letters[arr_anim_i];
			[letter setPosition:CGPointAdd(letter.origpt, ccp(0,20))];
			arr_anim_i++;
		} else {
			arr_anim_i = 0;
		}
		anim_ct = 4;
	}
	
	for (OrigPtCCSpr *letter in loading_letters) {
		[letter setPosition:ccp(
		 letter.position.x + (letter.origpt.x - letter.position.x)/4.0,
		 letter.position.y + (letter.origpt.y - letter.position.y)/4.0
		)];
	}
}



@end
