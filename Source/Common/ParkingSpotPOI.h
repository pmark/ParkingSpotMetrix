//
//  ParkingSpotPOI.h
//  Parkar
//
//  Created by P. Mark Anderson on 6/7/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "SM3DAR.h"


@interface ParkingSpotPOI : SM3DAR_PointOfInterest {

}

+ (id) parkingSpotPOIWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;

@end
