//
//  UpgradeItem.h
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

typedef enum
{
    UpgradeItemTypeNoAds,
    UpgradeItemTypeHistory,
    UpgradeItemTypeMeterTimer,
    UpgradeItemTypePhotos,
} UpgradeItemType;

@interface UpgradeItem : Model 
{

}

+ (UpgradeItem*) upgradeItemForType:(UpgradeItemType)type;
+ (NSDictionary*) propertiesFor:(UpgradeItemType)type;

@end
