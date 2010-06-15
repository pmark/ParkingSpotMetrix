//
//  ArrowFixture.m
//  Parkar
//
//  Created by P. Mark Anderson on 5/23/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "ArrowFixture.h"

@implementation ArrowFixture

@synthesize rotationDegrees;
@synthesize heading;

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
	self.heading = degrees;
    //NSLog(@"new arrow heading: %.1f", heading);
}

- (CGFloat) gearSpeed
{
    return 0.66;
}

- (NSInteger) numberOfTeethInGear
{
	return 359;    
}

- (void) gearHasTurned
{
    // rotate on x
    self.rotationDegrees = self.gearPosition;
}

@end
