//
//  PointerView.m
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/9/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "PointerView.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation PointerView

@synthesize currentScale;
@synthesize label;
@synthesize delegate;
@synthesize button;
@synthesize backgroundImage;
@synthesize paddingOffset;

- (void) dealloc 
{
    RELEASE(label);
    RELEASE(delegate);
    RELEASE(button);
    RELEASE(backgroundImage);
    [super dealloc];
}

- (id) initWithPadding:(CGPoint)padding image:(UIImage*)image
{    
    CGRect frame = CGRectMake(padding.x, padding.y, 
                       image.size.width, image.size.height);
    
    if ((self = [super initWithFrame:frame])) 
    {
        currentScale = 1.0;
        
        self.backgroundImage = image;
        self.paddingOffset = padding;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [button setImage:image forState:UIControlStateNormal];    
        [button setImage:image forState:UIControlStateHighlighted];    
        [button addTarget:self action:@selector(wasTapped) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = NO;
        [self addSubview:button];
        [self updateCenterPoint];
    }
    return self;
}

- (void) wasTapped
{
    NSLog(@"Pointer wasTapped");
    if (!delegate)
        return;
    
    [delegate pointerWasTapped:self];
}

- (CGFloat) edgeLength
{
	return backgroundImage.size.width * currentScale;
}

- (void) updateCenterPoint
{
    CGFloat len = [self edgeLength] / 2.0;
    CGFloat xpos = paddingOffset.x + len;
    CGFloat ypos = paddingOffset.y + len;
    self.center = CGPointMake(xpos, ypos);    
}

- (void) updateTransform
{
    self.transform = CGAffineTransformConcat(
                         CGAffineTransformMakeScale(currentScale, currentScale), 
                         CGAffineTransformMakeRotation(currentRadians));
}

// Scale up or down.
- (void) toggleState
{
    if (changingState)
        return;
    
	changingState = YES;    
    
    if (currentScale < 1.0)
    {
        // expand
        currentScale = 1.0;        
    }
    else
    {
        // shrink
        currentScale = 0.3;
    }


    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.33];
    [UIView setAnimationDidStopSelector:@selector(stateToggleComplete)];
    [UIView setAnimationDelegate:self];
    
	[self updateTransform];
    [self updateCenterPoint];
    
    [UIView commitAnimations];    
}

- (void) stateToggleComplete
{
	changingState = NO;    
}

- (void) rotate:(CGFloat)radians duration:(CGFloat)duration
{
    if (changingState)
        return;
    
    currentRadians = radians;

    [UIView setAnimationsEnabled:NO];
    [UIView setAnimationsEnabled:YES];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    [self updateTransform];
    
    [UIView commitAnimations];    
}

@end
