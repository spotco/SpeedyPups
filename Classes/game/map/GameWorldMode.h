#import <Foundation/Foundation.h>

typedef enum {
	BGMode_NORMAL,
	BGMode_LAB
} BGMode;

typedef enum { //worlds are incremented by labentrances, only further created lineislands will be affected
	WorldNum_1 = 1,
	WorldNum_2 = 2,
	WorldNum_3 = 3
} WorldNum;

typedef enum { //labs incremented by labexits, keep these synchronized with worldnum
	LabNum_1 = 1,
	LabNum_2 = 2,
	LabNum_3 = 3
} LabNum;

//update when available
#define MAX_WORLD WorldNum_3
#define MAX_LAB LabNum_3

typedef enum { //values processed by FreeRunProgressAnimation
	FreeRunProgress_PRE_1 = 0, //world1
	FreeRunProgress_1 = 1,	   //before lab1
	FreeRunProgress_PRE_2 = 2, //world2
	FreeRunProgress_2 = 3,     //before lab2
	FreeRunProgress_PRE_3 = 4, //world3
	FreeRunProgress_3 = 5,	   //before lab3
	FreeRunProgress_POST_3 = 6 //after lab3
} FreeRunProgress;

@interface GameWorldMode : NSObject

+(BGMode)get_bgmode;
+(WorldNum)get_worldnum;
+(WorldNum)get_actual_worldnum;
+(LabNum)get_labnum;

+(void)reset;

+(void)increment_world;
+(FreeRunProgress)get_freerun_progress;
+(void)freerun_progress_about_to_enter_lab;

+(void)set_bgmode:(BGMode)b;
+(void)set_worldnum:(WorldNum)w;

@end
