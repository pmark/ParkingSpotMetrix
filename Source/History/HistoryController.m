//
//  HistoryController.m
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "HistoryController.h"
#import "NSUserDefaults+Database.h"

#define SECTION_CURRENT_SPOT 	0
#define SECTION_PAST_SPOTS 		1

@implementation HistoryController

- (void) dealloc 
{
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        NSLog(@"hi");
        
        // One strategy:
        // store an array here
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (IBAction) clear
{
    
}

#pragma mark -

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *cid = @"cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cid];
    
    if (!cell) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case SECTION_CURRENT_SPOT:
            cell.textLabel.text = @"None";
            break;
        case SECTION_PAST_SPOTS:
            cell.textLabel.text = @"None";
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }    

    cell.detailTextLabel.text = @"";
    
    // TODO:
    // address, or something else if don't have address?  lat/lng
    // timestamp
    // when selected, show on map...change parking spot but don't add to history?

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
