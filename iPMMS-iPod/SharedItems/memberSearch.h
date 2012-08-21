//
//  memberSearch.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"
#import "memberView.h"

@interface memberSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    
    NSString *_notificationName, *_proxynotification, *_webdataName, *_cacheName,*_gobacknotifyName;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    int _currControllerIndex;
    UIButton *btnCamera;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname;
- (void) setBarCodeFromPicker:(NSString*) p_barcode;

@end
