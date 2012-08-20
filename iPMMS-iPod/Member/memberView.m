//
//  memberView.m
//  iPMMS-iPod
//
//  Created by Macintosh User on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberView.h"

@implementation memberView

- (id)initWithFrame:(CGRect)frame withNewDataNotification:(NSString*)  p_proxynotificationname andIintDict:(NSDictionary*) p_initDict
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"frame left %f top %f width %f and height %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [super addNIBView:@"getSearch_iPod" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = UIInterfaceOrientationPortrait;
        _initDict = [NSDictionary dictionaryWithDictionary:p_initDict];
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"MEMBERDATAIPOD"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        [actIndicator startAnimating];
        navTitle.title = @"Member Data";
        navTitle.rightBarButtonItem = nil;
        navTitle.leftBarButtonItem = nil;
        UIBarButtonItem *mbrBtn = [[UIBarButtonItem alloc] initWithTitle:@"Member" style:UIBarButtonItemStylePlain target:self action:@selector(memberButtonPressed:)];
        navTitle.leftBarButtonItem = mbrBtn;
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
        populationOnProgress = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberViewDataGenerated:)  name:_proxynotification object:nil];
        gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:_initDict andNotificatioName:_proxynotification];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    
}

- (void) memberViewDataGenerated:(NSNotification *)generatedInfo
{
    UIBarButtonItem *btnCheckStatus;
    int isCheckedOut = 0;
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    _dispDict = [NSDictionary dictionaryWithDictionary:[dataForDisplay objectAtIndex:0]];
    isCheckedOut = [[_dispDict valueForKey:@"ISCHECKEDOUT"] intValue];
    if (isCheckedOut) 
        btnCheckStatus = [[UIBarButtonItem alloc] initWithTitle:@"Check In" style:UIBarButtonItemStylePlain target:self action:@selector(memberButtonPressed:)];
    else
        btnCheckStatus = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(memberButtonPressed:)];
        
    navTitle.rightBarButtonItem = btnCheckStatus;
    
    populationOnProgress = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_proxynotification object:nil];
    [self generateTableView];
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
    ystartPoint = 45;
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
    if ([tableView isEqual:_firstRowTV]) 
    {
        return 1;
    }

    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:_firstRowTV]) 
    {
        return 2;
    }
    
    int l_rnoofrows = 0;
    switch (section) 
    {
        case 0:
            l_rnoofrows = 1;
            break;
        case 1:
            l_rnoofrows = 3;
            break;
        case 2:
            l_rnoofrows = 4;
            break;
        case 3:
            l_rnoofrows = 2;
            break;
        default:
            break;
    }
    return  l_rnoofrows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_firstRowTV]) 
    {
        return 25;
    }

    int l_rowHeight = 0;
    switch (indexPath.section) 
    {
        case 0:
            l_rowHeight = 50;
            break;
        default:
            l_rowHeight = 25;
            break;
    }
    return  l_rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_firstRowTV]) 
    {
        return [self getFirstRowCell:indexPath.row];
    }
    
    switch (indexPath.section) 
    {
        case 0:
            return [self getCellForFirstRowWithPicture];
            break;
        default:
            return [self getSingleContentCell:indexPath.row andForSection:indexPath.section];
            break;
    }    
    return nil;
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

- (UITableViewCell*) getCellForFirstRowWithPicture
{
    static NSString *cellid=@"cellFirstRow";
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    UIImageView *memberPhoto;
    int   lblWidth, txtWidth, cellHeight,  lblPosition ;
    lblWidth = 104; txtWidth =208; cellHeight = 25; lblPosition = 0;
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[dispTV backgroundColor];
        
        _firstRowTV = [[UITableView alloc] initWithFrame:CGRectMake(-10, -10,cell.frame.size.width - 58 , 60) style:UITableViewStyleGrouped];
        [_firstRowTV setBackgroundView:nil];
        [_firstRowTV setBackgroundView:[[UIView alloc] init]];
        [_firstRowTV setBackgroundColor:UIColor.clearColor];
        [_firstRowTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_firstRowTV setDelegate:self];
        [_firstRowTV setDataSource:self];
        [_firstRowTV setBounces:NO];
        _firstRowTV.userInteractionEnabled = NO;
        [cell.contentView addSubview:_firstRowTV];
        [_firstRowTV reloadData];
        
        memberPhoto = [[UIImageView alloc] init];
        [memberPhoto setFrame:CGRectMake(cell.frame.size.width - 75, 1, 50,50 )];
        [cell.contentView addSubview:memberPhoto];
        
        NSURL *urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//m%d.jpeg",MAIN_URL, WS_ENV, [[_initDict valueForKey:@"MEMBERID"]intValue]]];
        NSData *imgData = [NSData dataWithContentsOfURL:urlPath];
        memberPhoto.image = [UIImage imageWithData:imgData];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    

    return cell;
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

- (UITableViewCell*) getFirstRowCell:(int) p_rowno
{
    static NSString *cellid=@"cellSubFirstRow";
    UITextField *txtValue, *txttitle;
    UITableViewCell  *cell = [_firstRowTV dequeueReusableCellWithIdentifier:cellid];
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
        
        txtValue = [[UITextField alloc] initWithFrame:CGRectMake(83, 0, cell.frame.size.width- 95,25)];
        txtValue.borderStyle = UITextBorderStyleNone;
        txtValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtValue.tag = 2;
        txtValue.textAlignment = UITextAlignmentLeft;
        txtValue.font = cell.textLabel.font;
        txtValue.enabled = NO;
        [cell.contentView addSubview:txtValue];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    txttitle = (UITextField*) [cell.contentView viewWithTag:1];
    txtValue = (UITextField*) [cell.contentView viewWithTag:2];
    switch (p_rowno) 
    {
        case 0:
            cell.textLabel.text = @"Bar code";
            txtValue.text = [[NSString alloc] initWithFormat:@"  %@  ", [_dispDict valueForKey:@"BARCODE"]];
            break;
        case 1:
            cell.textLabel.text = @"Balance";
            txtValue.text = [[[NSString alloc] initWithFormat:@"  %@  ", [frm stringFromNumber:[NSNumber numberWithDouble:[[_dispDict valueForKey:@"CURRPENDING"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            break;
        default:
            break;
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

- (void) memberButtonPressed : (id) sender
{
    UIBarButtonItem *btnClicked = (UIBarButtonItem*) sender;
    if ([btnClicked.title isEqualToString:@"Member"]) 
    {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberStatusUpdated:)  name:@"memberStatusUpdated" object:nil];
    memberStatusChange *mbrCheck = [[memberStatusChange alloc] initWithFrame:self.frame withNewDataNotification:@"memberCheckNotesData_iPod" andIintDict:_dispDict];
    [self addSubview:mbrCheck];
    
}

- (void) memberStatusUpdated:(NSNotification*) p_notifyInfo
{
    NSString *recdRequest = [[p_notifyInfo userInfo] valueForKey:@"data"];    
    if ([recdRequest isEqualToString:@"Cancel"]) 
    {
        //NSLog(@"cancel is received from the status update request");
    }
    
    if ([recdRequest isEqualToString:@"Success"]) 
    {
        NSDictionary *returnInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Success",@"data", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"memberViewStatusReturn" object:nil userInfo:returnInfo];
        [self removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"memberStatusUpdated" object:nil];
}

@end
