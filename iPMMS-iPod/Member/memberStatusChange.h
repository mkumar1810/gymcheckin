//
//  memberStatusChange.h
//  iPMMS-iPod
//
//  Created by Macintosh User on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface memberStatusChange : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_proxynotification,*/ *_webdataName;
    NSDictionary *_dispDict;
    NSDictionary *_initDict;
    NSNumberFormatter *frm;
    int isCheckedOut;
    UISegmentedControl *scCheckinType;
    METHODCALLBACK _mbrStatusUpdateMethod;
}

- (id)initWithFrame:(CGRect)frame andIintDict:(NSDictionary*) p_initDict withStatusUpdateMethod:(METHODCALLBACK) p_statusUpdateMethod;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getCheckInTypeCell;
- (UITableViewCell*) getNotesDisplayCellforRow:(int) p_RowNo;
- (UITableViewCell*) getCurrStatusCell;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) memberCheckNotesDataGenerated:(NSDictionary *)generatedInfo;
- (void) memberCheckNotesStatusUpdated:(NSDictionary *)generatedInfo;

@end
