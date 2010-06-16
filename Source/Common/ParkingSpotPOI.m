//
//  ParkingSpotPOI.m
//  Parkar
//
//  Created by P. Mark Anderson on 6/7/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "ParkingSpotPOI.h"
#import "SphereView.h"
#import "ArrowView.h"

extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);

@implementation ParkingSpotPOI

+ (id) parkingSpotPOIWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    ParkingSpotPOI *poi = [[sm3dar initPointOfInterest:lat 
                                             longitude:lon 
                                              altitude:0 
                                                 title:@"" 
                                              subtitle:@"" 
                                       markerViewClass:[ArrowView class] 
                                            properties:nil] autorelease];
    
    poi.canReceiveFocus = NO;

    return poi;
}

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
