//
//  AboutController.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "AboutController.h"
#import "Constants.h"

@implementation AboutController

@synthesize webView;

- (void)dealloc {
    RELEASE(webView);
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    [webView loadHTMLString:@"<h2>About</h2>" baseURL:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
