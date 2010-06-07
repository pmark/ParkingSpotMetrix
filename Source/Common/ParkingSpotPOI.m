//
//  ParkingSpotPOI.m
//  Parkar
//
//  Created by P. Mark Anderson on 6/7/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "ParkingSpotPOI.h"
#import "SphereView.h"

extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);

@implementation ParkingSpotPOI

+ (id) parkingSpotPOIWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{
    NSDictionary *poiProperties = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   nil, @"title",
                                   nil, @"subtitle",
                                   @"SphereView", @"view_class_name",
                                   [NSNumber numberWithDouble:lat], @"latitude",
                                   [NSNumber numberWithDouble:lon], @"longitude",
                                   0, @"altitude",
                                   nil];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    ParkingSpotPOI *poi = [[sm3dar initPointOfInterest:poiProperties] autorelease];
    poi.canReceiveFocus = NO;
    return poi;
}

/*
- (id) init
{
    if (self = [super init])
    {
        SphereView *v = [[SphereView alloc] initWithTextureNamed:nil];
        self.view = v;
        v.point = self;
        [v release];
    }
    return self;
}
*/
- (CGFloat) gearSpeed 
{
    return 1.0;
}

- (NSInteger) numberOfTeethInGear 
{
    return 180;
}

- (void) gearHasTurned 
{
    Coord3D wp = self.worldPoint;
    
    Coord3D wp2 = {
        wp.x,
        wp.y,
        wp.z + (cos(degreesToRadians(self.gearPosition)) * 3),
    };
    
    self.worldPoint = wp2;
}

@end
