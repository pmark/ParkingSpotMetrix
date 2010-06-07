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
#import "TexturedGeometryView.h"

@interface ArrowFixture : SM3DAR_Fixture {
	CGFloat rotationDegrees;
	CGFloat heading;
}

- (id) initWithView:(TexturedGeometryView*)arrowView;
- (void) pointAt:(CGFloat)degrees;

@property (nonatomic, assign) CGFloat rotationDegrees;
@property (nonatomic, assign) CGFloat heading;

@end
