#import "LabBGObject.h"
#import "Resource.h"
#import "Common.h"

@implementation LabBGObject

+(LabBGObject*)cons {
    LabBGObject* bg = [LabBGObject spriteWithTexture:[Resource get_tex:TEX_LAB_BG]];
    bg.scrollspd_x = 0.7;
    bg.scrollspd_y = 0.4;
    bg.anchorPoint = CGPointZero;
    bg.position = CGPointZero;
    ccTexParams par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [bg.texture setTexParameters:&par];
    return bg;
}

-(void)update_posx:(float)posx posy:(float)posy {
    [self setTextureRect:CGRectMake(posx*scrollspd_x*0.1, 50, [Common SCREEN].width*2 ,[Common SCREEN].height)];
}

@end
