//
//  PointerView.h
//  ParkingSpotMetrix
//
//  Created by P. Mark Anderson on 5/9/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PointerButtonDelegate;

@interface PointerView : UIView {
	UILabel *label;
    CGFloat currentScale;
    CGFloat currentRadians;
    CGPoint paddingOffset;
    NSObject<PointerButtonDelegate> *delegate;
    UIButton *button;
    BOOL changingState;
    UIImage *backgroundImage;
}

@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) CGPoint paddingOffset;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) NSObject<PointerButtonDelegate> *delegate;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIImage *backgroundImage;

- (id) initWithPadding:(CGPoint)padding image:(UIImage*)image;
- (void) toggleState;
- (void) rotate:(CGFloat)radians duration:(CGFloat)duration;
- (void) updateCenterPoint;

@end

@protocol PointerButtonDelegate
- (void) pointerWasTapped:(PointerView*)pointerButton;
@end
