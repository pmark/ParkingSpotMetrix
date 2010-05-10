//
//  WharCarViewController.m
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import "WharCarViewController.h"
#import "Constants.h"
#import "RoundedLabelMarkerView.h"

#define BTN_TITLE_SET_SPOT @"Drop Pin"
#define BTN_TITLE_RESET_SPOT @"Reset"

#define POINTER_UPDATE_SEC 0.85
#define HEADING_DELTA_THRESHOLD 5

@implementation WharCarViewController

@synthesize screen1;
@synthesize screen2;
@synthesize crosshairs;
@synthesize parkButton;
@synthesize parkingSpot;
@synthesize pointer;

- (void)dealloc 
{
    RELEASE(screen1);
    RELEASE(screen2);
    RELEASE(crosshairs);
    RELEASE(parkButton);
    RELEASE(parkingSpot);
    RELEASE(pointer);
    RELEASE(hudTimer);
    [super dealloc];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        // Custom initialization
        lastHeading = 0.0;
    }
    return self;
}

- (SM3DAR_PointOfInterest*) addPOI:(NSString*)title subtitle:(NSString*)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon  canReceiveFocus:(BOOL)canReceiveFocus 
{
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    NSDictionary *poiProperties = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   title, @"title",
                                   subtitle, @"subtitle",
                                   @"RoundedLabelMarkerView", @"view_class_name",
                                   [NSNumber numberWithDouble:lat], @"latitude",
                                   [NSNumber numberWithDouble:lon], @"longitude",
                                   0, @"altitude",
                                   nil];
    
    SM3DAR_PointOfInterest *poi = [[sm3dar initPointOfInterest:poiProperties] autorelease];    
    poi.canReceiveFocus = canReceiveFocus;
    [sm3dar addPointOfInterest:poi];
    return poi;
}

- (void) zoomMapIn
{
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center = sm3dar.currentLocation.coordinate;
	region.span.longitudeDelta = 0.0001f;
	region.span.latitudeDelta = 0.0001f;
	[sm3dar.map setRegion:region animated:YES];
}

- (void) loadPointsOfInterest
{
    // Add compass points.
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    CLLocationCoordinate2D currentLoc = [sm3dar currentLocation].coordinate;
    CLLocationDegrees lat=currentLoc.latitude;
    CLLocationDegrees lon=currentLoc.longitude;
    
    [self addPOI:@"N" subtitle:@"" latitude:(lat+0.01f) longitude:lon canReceiveFocus:NO];
    [self addPOI:@"S" subtitle:@"" latitude:(lat-0.01f) longitude:lon canReceiveFocus:NO];
    [self addPOI:@"E" subtitle:@"" latitude:lat longitude:(lon+0.01f) canReceiveFocus:NO];
    [self addPOI:@"W" subtitle:@"" latitude:lat longitude:(lon-0.01f) canReceiveFocus:NO];
    
    [self performSelector:@selector(zoomMapIn) withObject:nil afterDelay:2.0];

    [self bringActiveScreenToFront];
}

- (void) buildScreen1
{
    if (screen1)
        return;
    
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 420, 320, 60)];
    [self.view addSubview:v];
    self.screen1 = v;
    [v release];

    UIView *bg = [[UIView alloc] initWithFrame:v.frame];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.2f;    
    [screen1 addSubview:bg];
    [bg release];

    // button
    self.parkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [parkButton setTitle:BTN_TITLE_SET_SPOT forState:UIControlStateNormal];
    [parkButton addTarget:self action:@selector(toggleParkingSpot) forControlEvents:UIControlEventTouchUpInside];
    [parkButton sizeToFit];
    [screen1 addSubview:parkButton];
    parkButton.center = screen1.center;

    // crosshairs
    UIImage *img = [UIImage imageNamed:@"3dar_marker_icon1.png"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    iv.center = self.view.center;
    [screen1 addSubview:iv];
    self.crosshairs = iv;
    iv.alpha = 0.0f;
    [iv release];
}

- (void) buildHUD
{
    // pointer
    self.pointer = [[[PointerView alloc] initWithPadding:CGPointMake(10, 10) image:[UIImage imageNamed:@"compass_rose_g_300.png"]] autorelease];
    pointer.delegate = self;
    pointer.currentScale = 0.3;
    pointer.transform = CGAffineTransformMakeScale(pointer.currentScale, pointer.currentScale);
    [pointer updateCenterPoint];
    [self.view addSubview:pointer];
    
    hudTimer = [NSTimer scheduledTimerWithTimeInterval:POINTER_UPDATE_SEC target:self selector:@selector(updateHUD) userInfo:nil repeats:YES];
}

- (void) viewDidLoad 
{
    NSLog(@"\n\nWCVC: viewDidLoad\n\n");
    [super viewDidLoad];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.delegate = self;
    sm3dar.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sm3dar.view];
    
    [self buildScreen1];    
    
    [self buildHUD];
    

	[self bringActiveScreenToFront];    
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    NSLog(@"\n\nWCVC: viewDidUnload\n\n");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) bringActiveScreenToFront
{
	screen1.hidden = NO;
    [self.view bringSubviewToFront:screen1];
}

- (void) locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation 
{
    if (!parkingSpot && crosshairs.alpha < 0.1)
    {
        [self performSelector:@selector(showCrosshairs) withObject:nil afterDelay:2.0];
    }
}

- (CGPoint) centerPoint
{
	return CGPointMake(160, 220);    
}

- (void) showCrosshairs
{
    [self setCrosshairsHidden:NO];
}

- (void) setCrosshairsHidden:(BOOL)hide
{
    CGFloat alpha = (hide ? 0.0 : 1.0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    crosshairs.alpha = alpha;
    [UIView commitAnimations];
}

- (void) toggleParkingSpot
{
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];

    if (parkingSpot)
    {
        // remove it
        [sm3dar removePointOfInterest:parkingSpot];
        self.parkingSpot = nil;
        [self setCrosshairsHidden:NO];
        [parkButton setTitle:BTN_TITLE_SET_SPOT forState:UIControlStateNormal];
    }
    else
    {
        // drop a pin
        CLLocationCoordinate2D currentLoc = [sm3dar.map convertPoint:CGPointMake(160, 250)
                                                toCoordinateFromView:self.view];
        CLLocationDegrees lat = currentLoc.latitude;
        CLLocationDegrees lon = currentLoc.longitude;
        
        self.parkingSpot = [self addPOI:@"P" subtitle:@"distance" latitude:lat longitude:lon canReceiveFocus:YES];
        
        UILabel *parkingSpotLabel = ((RoundedLabelMarkerView*)parkingSpot.view).label;
        parkingSpotLabel.backgroundColor = [UIColor whiteColor];
        parkingSpotLabel.textColor = [UIColor blackColor];
        
        
        [sm3dar.map addAnnotation:parkingSpot];        
        
        
        [parkButton setTitle:BTN_TITLE_RESET_SPOT forState:UIControlStateNormal];
        [self setCrosshairsHidden:YES];
    }
}

- (void) didShowMap 
{
    [self bringActiveScreenToFront];
}

- (void) didHideMap 
{
	screen1.hidden = YES;
}

- (void) updateHUD
{
    if (!pointer)
        return;
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];    
    if (abs(lastHeading - sm3dar.trueHeading) < HEADING_DELTA_THRESHOLD)
    	return;

    lastHeading = sm3dar.trueHeading;

    extern float degreesToRadians(float degrees);    
    CGFloat radians = -degreesToRadians(lastHeading);
    [pointer rotate:radians duration:(POINTER_UPDATE_SEC*0.99)];  
}

- (void) pointerWasTapped:(PointerView*)pointerView
{
    [pointerView toggleState];
}

@end
