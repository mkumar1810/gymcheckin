//
//  memberController.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberController.h"

@implementation memberController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Members", @"Members");
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
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
    [self initialize];
    [super viewDidLoad];
    [self setViewResizedForOrientation:currOrientation];
    // Do any additional setup after loading the view from its nib.
}


- (void) initialize
{
    //[[NSNotificaxxxtionCenter defaultCenter] addObserver:self selector:@selector(searchMemberReturn:) name:@"searchMemberReturn" object:nil];   
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    [self generateMembersList];
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
    [self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if (memSearch) 
        [memSearch setForOrientation:p_intOrientation];
    /*if (UIInterfaceOrientationIsLandscape(currOrientation)) 
        [self addAddButton];*/
}

- (void) generateMembersList
{
    myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    METHODCALLBACK _mbrSearchReturn = ^ (NSDictionary* p_dictInfo)
    {
        [self searchMemberReturn:p_dictInfo];
    };
    METHODCALLBACK _mbrBarCodeScan = ^ (NSDictionary* p_dictInfo)
    {
        [self scanMemberBarcode:p_dictInfo];
    };
    
    memSearch = [[memberSearch alloc] initWithFrame:myFrame forOrientation:currOrientation  andReturnMethod:_mbrSearchReturn andBarCodeScanMethod:_mbrBarCodeScan];
    [self.view addSubview:memSearch];
}

- (void) searchMemberReturn:(NSDictionary *)memberInfo
{
    signIn *resignIn = [[signIn alloc] init];
    [self.navigationController pushViewController:resignIn animated:NO];
}

- (IBAction) ButtonPressed:(id)sender
{
    UIBarButtonItem *recdBtn = (UIBarButtonItem*) sender;
    switch (recdBtn.tag) {
        case 0: //refresh button pressed
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
             [memSearch refreshData:nil];
            break;
        default:
            break;
    }
}

- (void) scanMemberBarcode:(NSDictionary*) notifyInfo
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;

	
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
	
    // present and release the controller
    [self presentModalViewController: reader
							animated: YES];
	
	// remove below three lines for actual scan
	//NSString *barcode = [[NSString alloc] init];
	//barcode = @"2100000181230";
	//[self getBookData:barcode];
	
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info 
{
	//NSString *barcode = [[NSString alloc] init];
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
	
    [memSearch setBarCodeFromPicker:symbol.data];
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [memSearch setBarCodeFromPicker:@"1237"];
    [self dismissModalViewControllerAnimated:YES];
}


@end
