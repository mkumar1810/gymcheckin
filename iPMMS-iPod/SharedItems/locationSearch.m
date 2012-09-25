//
//  locationSearch.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 18/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "locationSearch.h"

@implementation locationSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnCallback:(METHODCALLBACK) p_cbReturn
         andIsSplit:(BOOL) p_issplitmode
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch_iPod" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        [actIndicator setFrame:CGRectMake(140, 202, 37, 37)];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"LOCATIONSLIST"];
        _cacheName = [[NSString alloc] initWithString:@"ALLLOCATIONS"];
        //[[NSNotificatxxionCenter defaultCenter] addObserver:self selector:@selector(locationListDataGenerated:)  name:_proxynotification object:nil];
        _returnMethod = p_cbReturn;
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden =NO;
        navTitle.rightBarButtonItem = nil;
        navTitle.title = @"Select a Location";
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
        __block id myself = self;
        METHODCALLBACK _wsReturnMethod = ^ (NSDictionary* p_dictInfo)
        {
            [myself locationListDataGenerated:p_dictInfo];
        };  
        gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andResponseMethod:_wsReturnMethod];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [self generateTableView];
}

- (void) locationListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    //NSLog(@"the received location list %@", dataForDisplay);
    [self setForOrientation:intOrientation];
    populationOnProgress = NO;
    [actIndicator stopAnimating];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
    //return;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    if (sBar.hidden==YES) 
        ystartPoint = 45;
    else
        ystartPoint = 45;
    tvrect = CGRectMake(0, ystartPoint, 320, 430);
    [sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
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
    return  50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    actIndicator.hidden = NO;
    [actIndicator startAnimating];
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"LocationSelected"] forKey:@"notify"];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    //[[NSNotificxxationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
    _returnMethod(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblGymName, *lblGymAddress;
    UIImageView *locPhoto;
    NSString *gymName, *gymAddress;
    NSURL *urlPath ;
    int lblWidth;
    lblWidth = 250;
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        locPhoto = [[UIImageView alloc] init];
        [locPhoto setFrame:CGRectMake(1, 1, 48, 48)];
        locPhoto.tag = 1;
        [cell.contentView addSubview:locPhoto];
        
        lblGymName = [[UILabel alloc] initWithFrame:CGRectMake(51, 1, lblWidth, 30)];
        lblGymName.font = [UIFont boldSystemFontOfSize:22.0f];
        [lblGymName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblGymName.tag = 2;
        [cell.contentView addSubview:lblGymName];
        
        lblGymAddress = [[UILabel alloc] initWithFrame:CGRectMake(51, 31, lblWidth, 20)];
        lblGymAddress.font = [UIFont boldSystemFontOfSize:15.0f];
        [lblGymAddress setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:170.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblGymAddress.tag = 3;
        [cell.contentView addSubview:lblGymAddress];
    }
    
    //NSLog(@"the dictionary data is %@",tmpDict);
    
    gymName = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"GYMNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    gymAddress = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"GYMADDRESS"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//GYM%d.JPG",HO_URL, WS_ENV, [[tmpDict valueForKey:@"GYMLOCATIONID"] intValue]]];
    //NSLog(@"the image location id %@", urlPath);
    locPhoto = (UIImageView*) [cell.contentView viewWithTag:1];
    lblGymName = (UILabel*) [cell.contentView viewWithTag:2];
    lblGymAddress = (UILabel*) [cell.contentView viewWithTag:3];
    locPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];
    lblGymName.text = gymName;
    lblGymAddress.text = gymAddress;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    //[dispTV removeFromSuperview];
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
    if ([currMode isEqualToString:@"L"]) 
    {
        [super searchBarSearchButtonClicked:searchBar];
        [self generateData];
    }
    else
        sBar.text = @"";
}

- (IBAction) goBack:(id) sender
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:nil forKey:@"data"];
    //[[NSNotificaxxtionCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
    _returnMethod(returnInfo);
}

@end
