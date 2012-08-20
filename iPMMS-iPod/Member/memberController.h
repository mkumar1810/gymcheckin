//
//  memberController.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberSearch.h"
#import "ZBarSDK.h"
#import "signIn.h"

@interface memberController : UIViewController <ZBarReaderDelegate>
{
    memberSearch *memSearch;
    //memberView *mbrView;
    UIInterfaceOrientation currOrientation;
    NSDictionary *currDict;
    BOOL firstLoad ;
    CGRect myFrame;
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) generateMembersList;
- (void) initialize;

@end
