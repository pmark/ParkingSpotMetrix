//
//  ArrowFixture.h
//  Parkar
//
//  Created by P. Mark Anderson on 5/23/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SM3DAR.h"
#import "ArrowView.h"

@interface ArrowFixture : SM3DAR_Fixture {
	CGFloat rotationDegrees;
}

- (id) initWithView:(ArrowView*)arrowView;

@property (nonatomic, assign) CGFloat rotationDegrees;

@end
