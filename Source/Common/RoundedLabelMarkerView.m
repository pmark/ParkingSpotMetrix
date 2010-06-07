//
//  RoundedLabelMarkerView.m
//  Panoramic
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "RoundedLabelMarkerView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation RoundedLabelMarkerView

@synthesize label;
@synthesize title;
@synthesize subtitle;

- (void) dealloc
{
    RELEASE(label);
    RELEASE(title);
    RELEASE(subtitle);
    [super dealloc];
}

- (void) buildView {
    NSString *distance = [self.poi formattedDistanceInMilesFromCurrentLocation];
    
    NSInteger fontSize = 18;
    self.label = [[[UILabel alloc] init] autorelease];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentCenter;

    CGFloat h;

    if ([self.subtitle isEqualToString:@"distance"])
    {
        h = (4*fontSize);
        label.text = [NSString stringWithFormat:@"%@\n%@ mi", self.title, distance];
        label.numberOfLines = 2;
    }
    else
    {
        h = (2*fontSize);
        label.text = self.title;
        label.numberOfLines = 1;
    }
    
    CGFloat padding = (3*fontSize);
    CGFloat w = ([self.title length] * fontSize) + padding;
	label.frame = self.frame = CGRectMake(0, 0, w, h);
    
	[self addSubview:label];
    
    CALayer *l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:7.0];
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
}

- (void) didReceiveFocus {
}

- (void) didLoseFocus {
}

#pragma mark -

- (void) drawInGLContext {  
}

- (NSString*) title {
    if ([title length] == 0) {
        if (self.poi)
            return self.poi.title;
    } else {
        return title;
    }
    return nil;
}

- (NSString*) subtitle {
    if ([subtitle length] == 0) {
        if (self.poi)
            return self.poi.subtitle;
    } else {
        return subtitle;
    }
    return nil;
}

@end
