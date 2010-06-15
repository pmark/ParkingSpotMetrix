//
//  HistoryController.m
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "HistoryController.h"


@implementation HistoryController

- (void) dealloc 
{
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

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
        case 0:
            cell.textLabel.text = @"None";
            break;
        case 1:
            cell.textLabel.text = @"None";
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }    

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