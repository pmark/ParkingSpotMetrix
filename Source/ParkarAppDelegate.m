//
//  WharCarAppDelegate.m
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import "ParkarAppDelegate.h"
#import "ParkarViewController.h"

@implementation ParkarAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    ParkarViewController *c = [[ParkarViewController alloc] init];
    self.viewController = c;
    [c release];

    viewController.view.frame = [UIScreen mainScreen].applicationFrame;
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
