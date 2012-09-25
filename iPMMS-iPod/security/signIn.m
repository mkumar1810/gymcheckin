//
//  signIn.m
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "signIn.h"

#import "memberController.h"

@implementation signIn

- (id) init   //WithNotificationName:(NSString*) p_notifyName
{
    self = [super initWithNibName:@"signIn_iPod" bundle:nil];
    if (self) {
    }
    return  self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    standardUserDefaults=[NSUserDefaults standardUserDefaults];
    CGRect myframe = [self.view bounds];
    currOrientation = self.interfaceOrientation;
    //signLogin = [[login alloc] initWithFrame:myframe andNotificationName:p_notifyName withOrient
    METHODCALLBACK loginReturn = ^ (NSDictionary* p_dictInfo)
    {
        [self loginSuccessful:p_dictInfo];
    };
    signLogin = [[login alloc] initWithFrame:myframe andNotificationMethod:loginReturn withOrientation:currOrientation];
    signLogin.tag = 1001;
    [self.view addSubview:signLogin];
    [super viewDidLoad];
    //[signLogin Login];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currOrientation = toInterfaceOrientation;
    [signLogin setForOrientation:toInterfaceOrientation];
}

- (void) loginSuccessful : (NSDictionary*) signInfo
{
    NSDictionary *returnedDict =  [[signInfo valueForKey:@"data"] objectAtIndex:0];
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) {
        NSString *loginuser = [returnedDict valueForKey:@"LOGGEDUSER"];
        NSString *shortName = [returnedDict valueForKey:@"SHORTNAME"];
        [standardUserDefaults setObject:[loginuser uppercaseString] forKey:@"USERCODE"];    
        [standardUserDefaults setObject:[shortName uppercaseString] forKey:@"SHORTNAME"];
        [[self.view viewWithTag:1001] removeFromSuperview];
        METHODCALLBACK loginReturn = ^ (NSDictionary* p_dictInfo)
        {
            [self locationNotifyLogin:p_dictInfo];
        };
        locSearch = [[locationSearch alloc] initWithFrame:self.view.frame forOrientation:currOrientation andReturnCallback:loginReturn andIsSplit:NO];
        [self.view addSubview:locSearch];
    }
    else
        [self showAlertMessage:respMsg];
}

- (void) locationNotifyLogin : (NSDictionary*) locInfo
{
    NSDictionary *recdData = [locInfo valueForKey:@"data"];
    if (recdData) 
    {
        [standardUserDefaults setValue:[recdData valueForKey:@"GYMLOCATIONID"] forKey:@"LOGGEDLOCATION"];
        [standardUserDefaults setValue:[recdData valueForKey:@"IPADDRESS"] forKey:@"LOCATIONSERVER"];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(locIsSelected:) userInfo:nil repeats:NO];
        return;
    }
    else
    {
        [signLogin resetValues];
        [self.view addSubview:signLogin];
    }
    [locSearch removeFromSuperview];
    locSearch = nil;
}

-(void)locIsSelected:(NSTimer *)timer
{
    memberController *memController = [[memberController alloc] initWithNibName:@"memberController" bundle:nil];
    [self.navigationController pushViewController:memController animated:NO];
    [locSearch removeFromSuperview];
    locSearch = nil;
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
