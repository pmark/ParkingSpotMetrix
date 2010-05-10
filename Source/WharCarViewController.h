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

@interface WharCarViewController : UIViewController <SM3DAR_Delegate, CLLocationManagerDelegate, PointerButtonDelegate> {
	UIView *screen1;
    UIImageView *crosshairs;
    UIButton *parkButton;
	SM3DAR_PointOfInterest *parkingSpot;
    PointerView *pointer;
    NSTimer *hudTimer;
    CGFloat lastHeading;
}

@property (nonatomic, retain) IBOutlet UIView *screen1;
@property (nonatomic, retain) IBOutlet UIView *screen2;
@property (nonatomic, retain) IBOutlet UIImageView *crosshairs;
@property (nonatomic, retain) UIButton *parkButton;
@property (nonatomic, retain) SM3DAR_PointOfInterest *parkingSpot;
@property (nonatomic, retain) PointerView *pointer;

- (CGPoint) centerPoint;
- (void) toggleParkingSpot;
- (void) setCrosshairsHidden:(BOOL)hide;
- (void) bringActiveScreenToFront;
- (SM3DAR_PointOfInterest*) addPOI:(NSString*)title subtitle:(NSString*)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon  canReceiveFocus:(BOOL)canReceiveFocus;

@end

