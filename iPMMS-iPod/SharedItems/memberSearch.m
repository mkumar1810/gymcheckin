//
//  memberSearch.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberSearch.h"

@implementation memberSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch_iPod" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"MEMBERSLIST"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLMEMBERS"];
        _gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        _currControllerIndex = 0;
        [actIndicator startAnimating];
        navTitle.title = @"Select a Member";
        navTitle.rightBarButtonItem = nil;
        UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        navTitle.rightBarButtonItem = logoutBtn;
        sBar.text = @"";
        sBar.delegate = self;
        [self generateData];
    }
    return self;
}

- (void) logout : (id) sender
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchMemberReturn" object:nil userInfo:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchMemberReturn" object:nil];
}

- (void) setBarCodeFromPicker:(NSString*) p_barcode
{
    sBar.text = p_barcode;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberListDataGenerated:)  name:_proxynotification object:nil];
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sBar.text, @"p_searchtext" , nil];
        if (refreshTag==1) 
        {
            [inputDict setValue:[[NSString alloc] initWithString:@""] forKey:@"p_searchtext"];
            gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
        }
        else
        {
            if ([sBar.text isEqualToString:@""]) 
            {
                NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
                if ([stdDefaults valueForKey:_cacheName]==nil) 
                {
                    [inputDict setValue:[[NSString alloc] initWithString:@""] forKey:@"p_searchtext"];
                    gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
                }
                else
                {
                    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
                    [returnInfo setValue:[stdDefaults valueForKey:_cacheName] forKey:@"data"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:_proxynotification object:self userInfo:returnInfo];
                }
            }
            else
                gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andNotificatioName:_proxynotification];
        }
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    
}

- (void) memberListDataGenerated:(NSNotification *)generatedInfo
{
    NSDictionary *recdData = [generatedInfo userInfo];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    if ([sBar.text isEqualToString:@""]) 
    {
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        if ([dataForDisplay count]==0) 
            [stdDefaults setValue:nil forKey:_cacheName];
        else
            [stdDefaults setValue:dataForDisplay forKey:_cacheName];
    }
    populationOnProgress = NO;
    [actIndicator stopAnimating];
    [self generateTableView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
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
    sBarwidth = 276;
    btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(276,45, 44, 44)];
    btnCamera.titleLabel.text=@"";
    [btnCamera setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(getBarCodeFromCamera:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btnCamera]; 
    //btnCamera.enabled = NO;
    [sBar setFrame:CGRectMake(0, 45, sBarwidth, sBar.bounds.size.height)];
    ystartPoint = sBar.frame.origin.y + sBar.frame.size.height+1;
    reqdHeight =  (480-sBar.frame.origin.y-sBar.frame.size.height-1)/60;
    reqdHeight = reqdHeight*60;
    //NSLog(@"reqd height %d and ystart point is %d", reqdHeight, ystartPoint);
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        tvrect = CGRectMake(0, ystartPoint, 320, 480);
        [actIndicator setFrame:CGRectMake(141, 201, 37, 37)];
    }
    else
    {
        tvrect = CGRectMake(0, ystartPoint, 320,reqdHeight);
        [actIndicator setFrame:CGRectMake(141, 201, 37, 37)];
    }
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}

- (void) getBarCodeFromCamera : (id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getMemberBarCode" object:self userInfo:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataForDisplay count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberViewStatusReturn:)  name:@"memberViewStatusReturn" object:nil];
    memberView *mbrView  = [[memberView alloc] initWithFrame:self.frame withNewDataNotification:@"memberViewData_iPod" andIintDict:[dataForDisplay objectAtIndex:indexPath.row]];
    [self addSubview:mbrView];
}

- (void) memberViewStatusReturn:(NSNotification*) p_notifyInfo
{
    NSString *recdRequest = [[p_notifyInfo userInfo] valueForKey:@"data"];    
    if ([recdRequest isEqualToString:@"Cancel"]) 
    {
        NSLog(@"cancel is received from the view and status update request");
    }
    
    if ([recdRequest isEqualToString:@"Success"]) 
    {
        NSLog(@"success is received from the view and status update request");
        //[self generateData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"memberViewStatusReturn" object:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblFullName, *lblMobile, *lblNation, *lblAge;
    UIImageView *mbrPhoto;
    NSString *fullName, *mobile, *nationality, *age;
    NSURL *urlPath ;
    int labelHeight = 30;
    int lblShort, lblLong;
    lblShort = 87;
    lblLong = 130;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        mbrPhoto = [[UIImageView alloc] init];
        [mbrPhoto setFrame:CGRectMake(5, 5, 50, 50)];
        mbrPhoto.tag = 1;
        [cell.contentView addSubview:mbrPhoto];
        
        lblFullName = [[UILabel alloc] initWithFrame:CGRectMake(61, 1, 2*lblLong, labelHeight-1)];
        lblFullName.font = [UIFont systemFontOfSize:14.0f];
        lblFullName.tag = 2;
        [cell.contentView addSubview:lblFullName];

        lblMobile = [[UILabel alloc] initWithFrame:CGRectMake(61, 30, lblShort, labelHeight-1)];
        lblMobile.font = [UIFont systemFontOfSize:12.0f];
        lblMobile.tag = 4;
        [cell.contentView addSubview:lblMobile];
        
        lblNation = [[UILabel alloc] initWithFrame:CGRectMake(61+lblShort, 30, lblShort, labelHeight-1)];
        lblNation.font = [UIFont systemFontOfSize:12.0f];
        lblNation.tag = 5;
        [cell.contentView addSubview:lblNation];

        lblAge = [[UILabel alloc] initWithFrame:CGRectMake(61+2*lblShort, 30, lblShort, labelHeight-1)];
        lblAge.font = [UIFont systemFontOfSize:12.0f];
        lblAge.tag = 6;
        [lblAge setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblAge];
        [lblMobile setBackgroundColor:[UIColor blackColor]];
        [lblNation setBackgroundColor:[UIColor blackColor]];
        [lblAge setBackgroundColor:[UIColor blackColor]];
        lblMobile.textColor = [UIColor whiteColor];
        lblNation.textColor = [UIColor whiteColor];
        lblAge.textColor = [UIColor whiteColor];
        [lblFullName setBackgroundColor:[UIColor blackColor]];
        lblFullName.textColor = [UIColor whiteColor];
    }

    fullName = [[NSString alloc] initWithFormat:@" %@ %@",[tmpDict valueForKey:@"FIRSTNAME"],[tmpDict valueForKey:@"LASTNAME"]];
    mobile = [[[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"MOBILEPHONE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    nationality = [[[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"NATNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    age = [[[NSString alloc] initWithFormat:@"%@ Yrs  ", [tmpDict valueForKey:@"AGE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[tmpDict valueForKey:@"MEMBERID"]];
    NSData *imgData = [stdDefaults valueForKey:imgName];
    if (!imgData) 
    {
        urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//m%d.jpeg",MAIN_URL, WS_ENV, [[tmpDict valueForKey:@"MEMBERID"]intValue]]];
        imgData = [NSData dataWithContentsOfURL:urlPath];
        [stdDefaults setValue:imgData forKey:imgName];
    }
    
    UIImage *memImage = [UIImage imageWithData:imgData];
    mbrPhoto= (UIImageView*) [cell.contentView viewWithTag:1];
    mbrPhoto.image = memImage;

    lblFullName = (UILabel*) [cell.contentView viewWithTag:2];
    lblFullName.text = fullName;
    
    lblMobile = (UILabel*) [cell.contentView viewWithTag:4];
    lblMobile.text = mobile;
    
    lblNation = (UILabel*) [cell.contentView viewWithTag:5];
    lblNation.text = nationality;
    
    lblAge = (UILabel*) [cell.contentView viewWithTag:6];
    lblAge.text = age;
    return cell;
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
    }*/
    refreshTag = 1;
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
    //[actIndicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberListDataGenerated:)  name:_proxynotification object:nil];
    [self generateData];
}

- (IBAction) goBack:(id) sender
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:nil forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:_gobacknotifyName object:self userInfo:returnInfo];
}

@end
