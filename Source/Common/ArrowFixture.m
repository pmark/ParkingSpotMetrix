//
//  ArrowFixture.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/23/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "ArrowFixture.h"

@implementation ArrowFixture

@synthesize rotationDegreesX;
@synthesize rotationDegreesY;
@synthesize rotationDegreesZ;

- (id) initWithView:(TexturedGeometryView*)arrowView 
{
    if (self = [super init])
    {
        self.view = arrowView;  
        arrowView.point = self;        
    }
    return self;
}

- (void) pointAt:(CGFloat)degrees
{
	self.rotationDegreesZ = -degrees;
    //NSLog(@"new arrow heading: %.1f", degrees);
}

- (CGFloat) gearSpeed
{
    return 1.2;
}

- (NSInteger) numberOfTeethInGear
{
	return 359;    
}

- (void) gearHasTurned
{
    self.rotationDegreesY = self.gearPosition;
}

@end
