//
//  WharCarAppDelegate.h
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParkarViewController;

@interface ParkarAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ParkarViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ParkarViewController *viewController;

@end

