//
//  OscillatingFixture.m
//  DelSol
//
//  Created by P. Mark Anderson on 4/26/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "OscillatingFixture.h"

#define DEG2RAD(A)			((A) * 0.01745329278)
#define RAD2DEG(A)			((A) * 57.2957786667)

@implementation OscillatingFixture

- (CGFloat) gearSpeed {
    return 1.0;
}

- (NSInteger) numberOfTeethInGear {
    return 180;
}

- (void) gearHasTurned {
    Coord3D wp = self.worldPoint;
    
    Coord3D wp2 = {
        wp.x,
        wp.y,
        wp.z + (cos(DEG2RAD(self.gearPosition)) * 3),
    };
    
    self.worldPoint = wp2;
}

@end
