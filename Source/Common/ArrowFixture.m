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

- (id) initWithView:(ArrowView*)arrowView 
{
    if (self = [super init])
    {
        self.view = arrowView;  
        arrowView.point = self;        
    }
    return self;
}

- (CGFloat) gearSpeed
{
    return 1.0;
}

- (NSInteger) numberOfTeethInGear
{
	return 359;    
}

- (void) gearHasTurned
{
    // rotate on x
    //NSLog(@"pos: %.1f", self.gearPosition);
    self.rotationDegrees = self.gearPosition;
}

@end
