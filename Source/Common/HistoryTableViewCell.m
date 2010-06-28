//
//  HistoryTableViewCell.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 6/27/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "HistoryTableViewCell.h"


@implementation HistoryTableViewCell

@synthesize properties;

- (void)dealloc 
{
    [properties release];
    [super dealloc];
}

- (id) initWithReuseIdentifier:(NSString*)reuseIdentifier 
{
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) 
    {
        self.detailTextLabel.text = @"";
        // Initialization code
    }
    return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated 
{

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setProperties:(NSDictionary*)p
{
    [properties release];
    properties = nil;
    properties = [p retain];

    // TODO:
    // address, or something else if don't have address?  lat/lng
    // timestamp
    // when selected, show on map...change parking spot but don't add to history?
    
    
    self.textLabel.text = [p description];
}

@end
