//
//  memberView.h
//  iPMMS-iPod
//
//  Created by Macintosh User on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "memberStatusChange.h"


@interface memberView : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_proxynotification,*/ *_webdataName;
    NSDictionary *_dispDict;
    NSDictionary *_initDict;
    UITableView *_firstRowTV;
    NSNumberFormatter *frm;
    NSString *MAIN_URL;
    NSUserDefaults *stdDefaults;
    METHODCALLBACK _mvReturnMethod;
}

- (id)initWithFrame:(CGRect)frame andIintDict:(NSDictionary*) p_initDict withReturnCallback:(METHODCALLBACK) p_returnCallback;
- (UITableViewCell*) getCellForFirstRowWithPicture;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getFirstRowCell:(int) p_rowno;
- (UITableViewCell*) getSingleContentCell:(int) p_rowno andForSection:(int) p_sectionno;
- (void) memberViewDataGenerated:(NSDictionary *)generatedInfo;
- (void) memberStatusUpdated:(NSDictionary*) p_notifyInfo;

@end
