//
//  memberStatusChange.m
//  iPMMS-iPod
//
//  Created by Macintosh User on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberStatusChange.h"

@implementation memberStatusChange

- (id)initWithFrame:(CGRect)frame withNewDataNotification:(NSString*)  p_proxynotificationname andIintDict:(NSDictionary*) p_initDict
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"frame left %f top %f width %f and height %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [super addNIBView:@"getSearch_iPod" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = UIInterfaceOrientationPortrait;
        _initDict = [NSDictionary dictionaryWithDictionary:p_initDict];
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"MEMBERNOTESFORSTATUSCHANGE"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        [actIndicator startAnimating];
        navTitle.title = @"Member Data";
        isCheckedOut = [[_initDict valueForKey:@"ISCHECKEDOUT"] intValue];
        if (isCheckedOut) 
            [navTitle setTitle:@"Check In"];
        else
            [navTitle setTitle:@"Check Out"];
        UIBarButtonItem *btnConfirm = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonPressed:)];
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonPressed:)];
        navTitle.leftBarButtonItem = btnCancel;
        navTitle.rightBarButtonItem = btnConfirm;
        sBar.text = @"";
        sBar.hidden = YES;
        sBar.delegate = self;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        [actIndicator startAnimating];
        populationOnProgress = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberCheckNotesDataGenerated:)  name:_proxynotification object:nil];
        gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:_initDict andNotificatioName:_proxynotification];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    
}

- (void) memberCheckNotesDataGenerated:(NSNotification *)generatedInfo
{
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    //_dispDict = [NSDictionary dictionaryWithDictionary:[dataForDisplay objectAtIndex:0]];
    
    populationOnProgress = NO;
    [actIndicator stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_proxynotification object:nil];
    [self generateTableView];
}

- (void) memberCheckNotesStatusUpdated:(NSNotification *)generatedInfo
{
    NSDictionary *returnedDict =  [[[generatedInfo userInfo] valueForKey:@"data"] objectAtIndex:0];
    NSLog(@"the received dictionary %@",returnedDict);
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    [actIndicator stopAnimating];
    if ([respCode isEqualToString:@"0"]) 
    {
        [self removeFromSuperview];
        NSDictionary *returnInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Success",@"data", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"memberStatusUpdated" object:nil userInfo:returnInfo];
    }
    else    
        [self showAlertMessage:respMsg];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"memberCheckNotesStatusUpdated" object:nil];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) generateTableView
{
    int ystartPoint;
    int reqdHeight;
    if (dispTV) 
    {
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            [actIndicator setFrame:CGRectMake(141, 281, 37, 37)];
        else
            [actIndicator setFrame:CGRectMake(141, 361, 37, 37)];
        [dispTV reloadData];
        [actIndicator stopAnimating];
        return;
    }
    CGRect tvrect;
    ystartPoint = 60;
    reqdHeight =  480-ystartPoint;
    //NSLog(@"reqd height %d and ystart point is %d", reqdHeight, ystartPoint);
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        tvrect = CGRectMake(0, ystartPoint, 320, reqdHeight);
        [actIndicator setFrame:CGRectMake(141, 201, 37, 37)];
    }
    else
    {
        tvrect = CGRectMake(0, ystartPoint, 320,reqdHeight);
        [actIndicator setFrame:CGRectMake(141, 201, 37, 37)];
    }
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [dispTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [actIndicator stopAnimating];
    
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isCheckedOut) 
        return 2;
    else
        return 1;
    
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    int l_rnoofrows = 0;
    switch (section) 
    {
        case 0:
            if (isCheckedOut) 
                l_rnoofrows = 2;
            else
                l_rnoofrows = [dataForDisplay count];
            break;
        case 1:
            l_rnoofrows = [dataForDisplay count];
            break;
        default:
            break;
    }
    return  l_rnoofrows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int l_rowheight;
    switch (indexPath.section) 
    {
        case 0:
            if (isCheckedOut) 
                l_rowheight = 25;
            else
                l_rowheight = 55;
            break;
        default:
            l_rowheight = 55;
            break;
    }
    return  l_rowheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
     [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
     [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case 0:
            if (isCheckedOut) 
            {
                if (indexPath.row==0) 
                    return [self getCurrStatusCell];
                else
                    return [self getCheckInTypeCell];
            }
            else
                return [self getNotesDisplayCellforRow:indexPath.row];
                
            break;
        default:
            return [self getNotesDisplayCellforRow:indexPath.row];
            break;
    }    
    return nil;
}

- (UITableViewCell*) getCurrStatusCell
{
    static NSString *cellid=@"cellDisplayStatus";
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lblTitle, *lblStatus;
    int labelHeight = 24;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 100; lblLongWidth = 200;
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:12.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        xPosition = 0; xWidth = lblShortWidth-1;
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblTitle.font = txtfont;
        [lblTitle setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        //[lblEntryDate setBackgroundColor:[UIColor whiteColor]];
        lblTitle.tag = 1;
        lblTitle.numberOfLines = 2;
        [lblTitle setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblTitle];
        
        xPosition += xWidth; xWidth = lblLongWidth-1;
        lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblStatus.font = txtfont;
        [lblStatus setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        //[lblNotes setBackgroundColor:[UIColor whiteColor]];
        lblStatus.tag = 2;
        lblStatus.numberOfLines = 3;
        [lblStatus setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblStatus];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    lblTitle = (UILabel*) [cell.contentView viewWithTag:1];
    lblTitle.text = @" Curr Status";
    lblStatus = (UILabel*) [cell.contentView viewWithTag:2];
    lblStatus.text = [NSString stringWithFormat:@" %@",[_initDict valueForKey:@"CURRSTATUS"]];
    
    return cell;
}

- (UITableViewCell*) getCheckInTypeCell
{
    static NSString *cellid=@"cellCheckin";
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lblTitle;
    int labelHeight = 24;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 100; lblLongWidth = 200;
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:12.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        xPosition = 0; xWidth = lblShortWidth-1;
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblTitle.font = txtfont;
        lblTitle.text = @" Check Mode";
        [lblTitle setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        [lblTitle setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblTitle];
        
        xPosition += xWidth; xWidth = lblLongWidth-1;
        NSArray *scData = [NSArray arrayWithObjects:@"Regular", @"Oth. Visit", nil];
        scCheckinType  = [[UISegmentedControl alloc] initWithItems:scData];
        NSDictionary *colorAttrib = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        NSDictionary *bcAttrib = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextShadowColor];
        [scCheckinType setTitleTextAttributes:colorAttrib 
                                       forState:UIControlStateNormal];
        [scCheckinType setTitleTextAttributes:bcAttrib 
                                       forState:UIControlStateNormal];
        [scCheckinType setFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        [cell.contentView addSubview:scCheckinType];
        if ([[_initDict valueForKey:@"CURRSTATUS"] isEqualToString:@"Active"]) 
            scCheckinType.enabled = YES;
        else
        {
            scCheckinType.enabled = NO;
            scCheckinType.selectedSegmentIndex = 1;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (UITableViewCell*) getNotesDisplayCellforRow:(int) p_RowNo
{
    static NSString *cellid=@"cellDisplay";
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lblEntryDate, *lblNotes;
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:p_RowNo];
    int labelHeight = 54;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 100; lblLongWidth = 200;
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:12.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        xPosition = 0; xWidth = lblShortWidth-1;
        lblEntryDate = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblEntryDate.font = txtfont;
        [lblEntryDate setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        //[lblEntryDate setBackgroundColor:[UIColor whiteColor]];
        lblEntryDate.tag = 1;
        lblEntryDate.numberOfLines = 2;
        [lblEntryDate setTextAlignment:UITextAlignmentCenter];
        [cell.contentView addSubview:lblEntryDate];
        
        xPosition += xWidth; xWidth = lblLongWidth-1;
        lblNotes = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblNotes.font = txtfont;
        [lblNotes setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        //[lblNotes setBackgroundColor:[UIColor whiteColor]];
        lblNotes.tag = 2;
        lblNotes.numberOfLines = 3;
        [lblNotes setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblNotes];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    lblEntryDate = (UILabel*) [cell.contentView viewWithTag:1];
    lblEntryDate.text = [NSString stringWithFormat:@"%@\n%@",[tmpDict valueForKey:@"ENTRYDATE"], [tmpDict valueForKey:@"ENTRYTIME"]];
    lblNotes = (UILabel*) [cell.contentView viewWithTag:2];
    lblNotes.text = [NSString stringWithFormat:@"%@", [tmpDict valueForKey:@"NOTES"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    /*NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
     for (NSDictionary *tmpDict in dataForDisplay) 
     {
     NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[tmpDict valueForKey:@"MEMBERID"]];
     [stdDefaults setValue:nil forKey:imgName];
     }
     refreshTag = 1;*/
    [self generateData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidBeginEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidEndEditing:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarSearchButtonClicked:searchBar];
    [self generateData];
}

- (IBAction) goBack:(id) sender
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
     [returnInfo setValue:nil forKey:@"data"];
     [[NSNotificationCenter defaultCenter] postNotificationName:_gobacknotifyName object:self userInfo:returnInfo];*/
}


- (UITableViewCell*) getEmptyCell
{
    static NSString *cellid=@"cellEmpty";
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}


- (UITableViewCell*) getSingleContentCell:(int) p_rowno andForSection:(int) p_sectionno
{
    static NSString *cellid=@"cellSingleContent";
    UITextField *txtValue;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        
        UILabel *lblDivider = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 1, 25)];
        lblDivider.backgroundColor = [UIColor grayColor];
        lblDivider.text = @"";
        [cell.contentView addSubview:lblDivider];
        
        txtValue = [[UITextField alloc] initWithFrame:CGRectMake(83, 0, cell.frame.size.width, 25)];
        txtValue.borderStyle = UITextBorderStyleNone;
        txtValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtValue.tag = 2;
        txtValue.textAlignment = UITextAlignmentLeft;
        txtValue.font = cell.textLabel.font;
        txtValue.enabled = NO;
        [cell.contentView addSubview:txtValue];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    txtValue = (UITextField*) [cell.contentView viewWithTag:2];
    if (p_sectionno==1) 
    {
        switch (p_rowno) 
        {
            case 0:
                cell.textLabel.text = @"First Name";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@ %@ ", [_dispDict valueForKey:@"FIRSTNAME"],[_dispDict valueForKey:@"LASTNAME"]];
                break;
                /*case 1:
                 cell.textLabel.text = @"Last Name";
                 txtValue.text = [[NSString alloc] initWithFormat:@"  %@  ", [_dispDict valueForKey:@"LASTNAME"]];
                 txtValue.text = [[[NSString alloc] initWithFormat:@"  %@  ", [frm stringFromNumber:[NSNumber numberWithDouble:[[_initDict valueForKey:@"CURRPENDING"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
                 break;*/
            case 1:
                cell.textLabel.text = @"Gender";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@  ", [_dispDict valueForKey:@"GENDER"]];
                break;
            case 2:
                cell.textLabel.text = @"DOB & Age";
                txtValue.text = [[[NSString alloc] initWithFormat:@"  %@        Age : %@ Yrs", [_dispDict valueForKey:@"BIRTHDATE"],[_dispDict valueForKey:@"AGE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
                break;
                /*case 4:
                 cell.textLabel.text = @"Age";
                 txtValue.text = [[[NSString alloc] initWithFormat:@"  %@ Yrs  ", [_dispDict valueForKey:@"AGE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
                 break;*/
            default:
                break;
        }
    }
    
    if (p_sectionno==2) 
    {
        switch (p_rowno) 
        {
            case 0:
                cell.textLabel.text = @"Cont Period";
                txtValue.text = [[NSString alloc] initWithFormat:@"  From %@ To %@ ", [_dispDict valueForKey:@"STARTDATE"], [_dispDict valueForKey:@"ENDDATE"]];
                break;
            case 1:
                cell.textLabel.text = @"Last Visit";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@ ", [_dispDict valueForKey:@"LASTVISIT"]];
                break;
            case 2:
                cell.textLabel.text = @"Next Due";
                //NSLog(@"the next due amount is %@  and db value is %@",[frm stringFromNumber:[NSNumber numberWithDouble:[[_initDict valueForKey:@"NEXTDUEAMT"] doubleValue]]], [_initDict valueForKey:@"NEXTDUEAMT"]);
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@        Amt : %@ ", [_dispDict valueForKey:@"NEXTDUEDATE"],[frm stringFromNumber:[NSNumber numberWithDouble:[[_dispDict valueForKey:@"NEXTDUEAMT"] doubleValue]]]];
                break;
            case 3:
                cell.textLabel.text = @"Curr Status";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@ ", [_dispDict valueForKey:@"CURRSTATUS"]];
                break;
            default:
                break;
        }
    }
    
    if (p_sectionno==3) 
    {
        switch (p_rowno) 
        {
            case 0:
                cell.textLabel.text = @"Mobile";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@  ", [_dispDict valueForKey:@"MOBILEPHONE"]];
                break;
            case 1:
                cell.textLabel.text = @"City";
                txtValue.text = [[NSString alloc] initWithFormat:@"  %@  -  %@", [_dispDict valueForKey:@"CITY"], [_dispDict valueForKey:@"EMIRATES"]];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void) actionButtonPressed : (id) sender
{
    UIBarButtonItem *btnClicked = (UIBarButtonItem*) sender;
    if ([btnClicked.title isEqualToString:@"Cancel"]) 
    {
        NSDictionary *returnInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel",@"data", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"memberStatusUpdated" object:nil userInfo:returnInfo];
        [self removeFromSuperview];
    }
    if ([btnClicked.title isEqualToString:@"Confirm"]) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberCheckNotesStatusUpdated:) name:@"memberCheckNotesStatusUpdated" object:nil];
        [actIndicator startAnimating];
        if (isCheckedOut) 
        {
            NSDictionary *updateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"] ,@"p_memberid" ,[NSString stringWithFormat:@"%d", scCheckinType.selectedSegmentIndex], @"p_checkintype"  , nil];
            gymWSCorecall = [[gymWSProxy alloc] initWithReportType:@"ADDCHECKIN" andInputParams:updateInfo andNotificatioName:@"memberCheckNotesStatusUpdated"];
        }
        else
        {
            NSDictionary *updateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[_initDict valueForKey:@"LASTVISITENTRYID"] ,@"p_checkinid", nil];
            gymWSCorecall = [[gymWSProxy alloc] initWithReportType:@"UPDATECHECKOUT" andInputParams:updateInfo andNotificatioName:@"memberCheckNotesStatusUpdated"];
        }
    }
}

@end
