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
    
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    int _currControllerIndex;
    UIButton *btnCamera;
    NSString *MAIN_URL;
    METHODCALLBACK _msReturnMethod;
    METHODCALLBACK _msBarcodMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andBarCodeScanMethod:(METHODCALLBACK) p_barcodeScan;
- (void) setBarCodeFromPicker:(NSString*) p_barcode;
- (void) memberListDataGenerated:(NSDictionary *)generatedInfo;
- (void) memberViewStatusReturn:(NSDictionary*) p_notifyInfo;
@end
