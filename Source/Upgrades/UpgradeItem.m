//
//  UpgradeItem.m
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "UpgradeItem.h"


@implementation UpgradeItem

NSDictionary *typeProperties = nil;

+ (UpgradeItem*) upgradeItemForType:(UpgradeItemType)type
{
    return [[[UpgradeItem alloc] initWithDictionary:[UpgradeItem propertiesFor:type]] autorelease];
}

+ (NSDictionary*) propertiesFor:(UpgradeItemType)type
{
    return typeProperties;    
}



@end
