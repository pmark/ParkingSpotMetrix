//
//  InfoController.h
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoController : UIViewController 
{
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIWebView *webView;

}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void) loadUpgradePage;
- (void) loadAboutPage;

@end
