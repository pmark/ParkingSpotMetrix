//
//  AboutController.h
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutController : UIViewController <UIWebViewDelegate> 
{
    IBOutlet UIWebView *webView;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
