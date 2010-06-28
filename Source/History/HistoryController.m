//
//  HistoryController.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "HistoryController.h"
#import "Constants.h"
#import "HistoryTableViewCell.h"
#import "NSUserDefaults+Database.h"

#define SECTION_CURRENT_SPOT 	0
#define SECTION_PAST_SPOTS 		1

@implementation HistoryController

@synthesize history;

- (void) dealloc 
{
    RELEASE(history);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.history = PREF_READ_ARRAY(PREF_KEY_SPOT_HISTORY);
    //NSLog(@"Loaded history: %@", history);

}

- (IBAction) clear
{
    
}

#pragma mark -

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *cid = @"cell";
    HistoryTableViewCell *cell = (HistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cid];

    if (!cell) 
    {
        cell = [[[HistoryTableViewCell alloc] initWithReuseIdentifier:cid] autorelease];
    }
    
    NSInteger historyIndex = 0;

    if (indexPath.section == SECTION_CURRENT_SPOT)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    else
    {
        historyIndex = indexPath.row + 1;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
    cell.properties = [history objectAtIndex:historyIndex];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Current Parking Spot";
            break;
        case 1:
            return @"Past Parking Spots";
            break;
        default:
            break;
    }
    
    return @"";
}

@end
