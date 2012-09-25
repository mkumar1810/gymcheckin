//
//  signIn.h
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "login.h"
#import "locationSearch.h"
#import "defaults.h"

@interface signIn : UIViewController 
{
    login *signLogin;
    locationSearch *locSearch;
    NSString *_notificationName;
    UIInterfaceOrientation currOrientation;
    NSUserDefaults *standardUserDefaults;
}

//- (id) initWithNotificationName:(NSString*) p_notifyName;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) loginSuccessful : (NSDictionary*) signInfo;
- (void) locationNotifyLogin : (NSDictionary*) locInfo;

@end
