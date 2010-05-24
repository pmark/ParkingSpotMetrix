//
//  WharCarViewController.h
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"
#import "PointerView.h"
#import "ArrowFixture.h"

@interface ParkarViewController : UIViewController <SM3DAR_Delegate, CLLocationManagerDelegate, PointerButtonDelegate> {
	UIView *screen1;
    UIImageView *dropTarget;
    UIButton *parkButton;
	SM3DAR_PointOfInterest *parkingSpot;
    ArrowFixture *arrow;
    PointerView *pointer;
    PointerView *compass;
    PointerView *instructions;
    NSTimer *hudTimer;
    CGFloat lastHeading;
    SM3DAR_Controller *sm3dar;
}

@property (nonatomic, retain) IBOutlet UIView *screen1;
@property (nonatomic, retain) IBOutlet UIImageView *dropTarget;
@property (nonatomic, retain) UIButton *parkButton;
@property (nonatomic, retain) SM3DAR_PointOfInterest *parkingSpot;
@property (nonatomic, retain) PointerView *pointer;
@property (nonatomic, retain) PointerView *compass;
@property (nonatomic, retain) PointerView *instructions;
@property (nonatomic, retain) ArrowFixture *arrow;

- (CGPoint) centerPoint;
- (void) toggleParkingSpot;
- (void) setDropTargetHidden:(BOOL)hide;
- (void) bringActiveScreenToFront;
- (SM3DAR_Fixture*) addFixtureWithView:(SM3DAR_PointView*)pointView;
- (SM3DAR_PointOfInterest*) addPOI:(NSString*)title subtitle:(NSString*)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon  canReceiveFocus:(BOOL)canReceiveFocus;
- (void) restoreSpot;
- (void) updatePointer;
- (BOOL) compassIsEnlarged;
- (void) addBackground;
- (void) addGroundPlane;
- (void) addArrow;

@end

