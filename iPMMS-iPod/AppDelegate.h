//
//  AppDelegate.h
//  iPMMS-iPod
//
//  Created by Macintosh User on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"

@class signIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *nav;
    METHODCALLBACK _callBackMethod;
    METHODCALLBACK _reloginCallBack;
}

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) signIn *viewController;

@end
