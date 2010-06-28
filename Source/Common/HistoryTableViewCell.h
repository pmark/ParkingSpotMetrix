//
//  HistoryTableViewCell.h
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 6/27/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryTableViewCell : UITableViewCell 
{
	NSDictionary *properties;
}

@property (nonatomic, retain) NSDictionary *properties;

- (id) initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
