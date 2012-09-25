//
//  defaults.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HO_URL @"http://192.168.1.8/"
//#define HO_URL @"http://194.170.6.30/"
#define WS_ENV @"GYMWS"
#define NO_OF_DAYS_FOR_LINECHART 120
#define M_PI        3.14159265358979323846264338327950288   /* pi */
#define M_PI_BY_2      1.57079632679489661923132169163975144   /* pi/2 */
#define M_PI_BY_4      0.785398163397448309615660845819875721  /* pi/4 */
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0
#define kTextFieldHeight		30.0
#define kToolbarHeight          48

#define LOGIN_URL @"/usersecurity.asmx?op=userLogin"
#define LOCATIONS_URL @"/memberservice_ipod.asmx?op=LocationsData"
#define MEMBERSLIST_URL @"/memberservice_ipod.asmx?op=MembersList"
#define MEMBERDATAIPOD_URL @"/memberservice_ipod.asmx?op=getMemberData_iPod"
#define MEMBERNOTESFORSTATUS_URL @"/memberservice_ipod.asmx?op=GymMemberNotes_ipod"
#define MEMBERADDCHECKIN_URL @"/memberservice_ipod.asmx?op=gymCreateCheckIn_ipod"
#define MEMBERUPDATECHECKOUT_URL @"/memberservice_ipod.asmx?op=gymUpdateCheckOut_ipod"

typedef void (^METHODCALLBACK) (NSDictionary*);

@protocol defaults <NSObject>

@end
