//
//  WharCarAppDelegate.h
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WharCarViewController;

@interface WharCarAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WharCarViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WharCarViewController *viewController;

@end

