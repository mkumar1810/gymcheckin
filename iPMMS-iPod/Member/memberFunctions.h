//
//  memberFunctions.h
//  iPMMS-iPod
//
//  Created by Macintosh User on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol memberFunctions <NSObject>

@optional
// the below all are ipod functions
- (id) initControllerWithDictionary:(NSDictionary*) p_mbrDict;
- (void) initializeWithDict:(NSDictionary*) p_baseDict;

// all below are ipad functions
/*
- (IBAction) ButtonPressed:(id)sender;
- (void) setEmptyMode;
- (void) setInsertMode;
- (void) executeCancel;
- (void) insertUpdatedata;
- (void) setListMode:(NSDictionary*) p_dictData;
- (void) executeSave;
- (void) setEditMode;
- (void) performAfterSave:(NSDictionary*) p_savedInfo;
- (NSString*) getXMLDataForSave;
- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode withScroll:(UIScrollView*) p_scrollView;
- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe;
- (void) refreshData;
- (void) clearScreen;
- (void) setFieldsEntryStatus:(BOOL) p_Status;
- (void) storeDispValues;
- (void) initializeVariables;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (BOOL) validateEntries;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName;
- (void) setKeyDictionary:(NSDictionary*) p_keyDict;
*/
@end
