//
//  NSUserDefaults+Database.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "NSUserDefaults+Database.h"


@implementation NSUserDefaults (Database)

- (void) addItemToTopOfArray:(id)item key:(NSString*)key maximum:(NSInteger)maximum
{
    if (item == nil) return;
    
    NSArray *items = nil;
    NSMutableArray *mutableItems = nil;
    NSData *data;
    
    data = [self objectForKey:key];
    
    if (data)
    {
        items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if (items == nil) 
    {
        mutableItems = [NSMutableArray array];
    } 
    else 
    {
        mutableItems = [NSMutableArray arrayWithArray:items];
    }
    
    if ([mutableItems containsObject:item]) 
    {
        [mutableItems removeObject:item];
    }
    
    [mutableItems insertObject:item atIndex:0];
    if ([mutableItems count] > maximum)
        [mutableItems removeLastObject];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:mutableItems];  

    NSLog(@"storing items: %@", mutableItems);
    [self setObject:data forKey:key];
}


- (NSMutableArray*) unarchiveArray:(NSString*)key
{
    NSData *data = [self objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


@end
