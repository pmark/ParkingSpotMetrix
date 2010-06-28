//
//  UpgradeDetailController.h
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpgradeItem.h"

@interface UpgradeDetailController : UIViewController 
{
	UpgradeItem *item;
}

@property (nonatomic, retain) UpgradeItem *item;

@end
