//
//  WharCarViewController.m
//  WharCar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import "ParkarViewController.h"
#import "Constants.h"
#import "RoundedLabelMarkerView.h"
#import "PointOfInterest.h"
#import "SphereView.h"
#import "GroundPlaneView.h"
#import "ArrowView.h"
#import "ParkarAppDelegate.h"

extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);

#define BTN_TITLE_SET_SPOT @"Drop Pin"
#define BTN_TITLE_RESET_SPOT @"Reset"

#define POINTER_UPDATE_SEC 0.75
#define HEADING_DELTA_THRESHOLD 5

#define COMPASS_PADDING_X_SHRUNK 10
#define COMPASS_PADDING_Y_SHRUNK 10
#define COMPASS_PADDING_X_ENLARGED 10
#define COMPASS_PADDING_Y_ENLARGED 85

#define INSTRUCTIONS_PADDING_X 0
#define INSTRUCTIONS_PADDING_Y 85

#define NEAR_CLIP_METERS 5
#define FAR_CLIP_METERS 161000

@implementation ParkarViewController

@synthesize screen1;
@synthesize dropTarget;
@synthesize parkButton;
@synthesize parkingSpot;
@synthesize pointer;
@synthesize compass;
@synthesize instructions;
@synthesize arrow;

- (void)dealloc 
{
    RELEASE(screen1);
    RELEASE(dropTarget);
    RELEASE(parkButton);
    RELEASE(parkingSpot);
    RELEASE(pointer);
    RELEASE(compass);
    RELEASE(instructions);
    RELEASE(hudTimer);
    [super dealloc];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        lastHeading = 0.0;
    }
    return self;
}

- (SM3DAR_PointOfInterest*) addPOI:(NSString*)title subtitle:(NSString*)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon  canReceiveFocus:(BOOL)canReceiveFocus 
{
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
    if (parkingSpot)
    {
        [sm3dar zoomMapToFitPointsIncludingUserLocation:YES];
    }
    else
    {
        MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
        region.center = sm3dar.currentLocation.coordinate;
        region.span.longitudeDelta = 0.0001f;
        region.span.latitudeDelta = 0.0001f;
        [sm3dar.map setRegion:region animated:YES];
    }
}

- (void) loadPointsOfInterest
{
    [self addBackground];
	[self addGroundPlane];
	[self addArrow];
    
    // Add compass points.
//    CLLocationCoordinate2D currentLoc = [sm3dar currentLocation].coordinate;
//    CLLocationDegrees lat=currentLoc.latitude;
//    CLLocationDegrees lon=currentLoc.longitude;
    
//    [self addPOI:@"N" subtitle:@"" latitude:(lat+0.01f) longitude:lon canReceiveFocus:NO];
//    [self addPOI:@"S" subtitle:@"" latitude:(lat-0.01f) longitude:lon canReceiveFocus:NO];
//    [self addPOI:@"E" subtitle:@"" latitude:lat longitude:(lon+0.01f) canReceiveFocus:NO];
//    [self addPOI:@"W" subtitle:@"" latitude:lat longitude:(lon-0.01f) canReceiveFocus:NO];
    
    [self restoreSpot];
	[self updatePointer];

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

    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.3f;    
    [screen1 addSubview:bg];
    [bg release];

    // button
    self.parkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [parkButton setTitle:BTN_TITLE_SET_SPOT forState:UIControlStateNormal];
    [parkButton addTarget:self action:@selector(toggleParkingSpot) forControlEvents:UIControlEventTouchUpInside];
    [parkButton sizeToFit];
    [screen1 addSubview:parkButton];
    parkButton.center = CGPointMake(160, 30);

    // dropTarget
    UIImage *img = [UIImage imageNamed:@"3dar_marker_icon1.png"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    CGPoint p = self.view.center;
    iv.center = CGPointMake(p.x, p.y-16);
    [self.view addSubview:iv];
    self.dropTarget = iv;
    iv.alpha = 0.0f;
    [iv release];
}

- (void) buildHUD
{
    // compass
    self.compass = [[[PointerView alloc] initWithPadding:CGPointMake(COMPASS_PADDING_X_SHRUNK, COMPASS_PADDING_Y_SHRUNK) 
                                                   image:[UIImage imageNamed:@"compass_rose_g_300.png"]] autorelease];
    compass.delegate = self;

    // minimize the compass
    compass.currentScale = 0.3;
    compass.transform = CGAffineTransformMakeScale(compass.currentScale, compass.currentScale);
    [compass updateCenterPoint];
    
    [self.view addSubview:compass];

    // pointer
    self.pointer = [[[PointerView alloc] initWithPadding:CGPointMake(104, 104) image:[UIImage imageNamed:@"wedge_92.png"]] autorelease];
    pointer.delegate = self;
    [compass addSubview:pointer];    

    // instructions
    self.instructions = [[[PointerView alloc] initWithPadding:CGPointMake(INSTRUCTIONS_PADDING_X, INSTRUCTIONS_PADDING_Y) image:[UIImage imageNamed:@"instructions_c.png"]] autorelease];
    instructions.delegate = nil;
    instructions.hidden = YES;
    [self.view addSubview:instructions];    
    
    hudTimer = [NSTimer scheduledTimerWithTimeInterval:POINTER_UPDATE_SEC target:self selector:@selector(updateHUD) userInfo:nil repeats:YES];
}

- (void) viewDidLoad 
{
    NSLog(@"\n\nWCVC: viewDidLoad\n\n");
    [super viewDidLoad];
    
    sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.delegate = self;
    sm3dar.nearClipMeters = NEAR_CLIP_METERS;
    sm3dar.farClipMeters = FAR_CLIP_METERS;
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
    if (sm3dar.mapIsVisible)
    {
        screen1.hidden = NO;
        dropTarget.hidden = NO;
        instructions.hidden = YES;
    }
    else 
    {
        screen1.hidden = YES;
        dropTarget.hidden = YES;        
        instructions.hidden = (parkingSpot != nil);
    }

    [self.view bringSubviewToFront:screen1];
}

- (void) locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation 
{
    if (!parkingSpot && dropTarget.alpha < 0.1)
    {
        [self performSelector:@selector(showDropTarget) withObject:nil afterDelay:2.0];
    }
}

- (CGPoint) centerPoint
{
	return CGPointMake(160, 220);    
}

- (void) showDropTarget
{
    [self setDropTargetHidden:NO];
}

- (void) setDropTargetHidden:(BOOL)hide
{
    CGFloat alpha = (hide ? 0.0 : 1.0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    dropTarget.alpha = alpha;
    [UIView commitAnimations];
}

- (void) setParkingSpotLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    self.parkingSpot = [self addPOI:@"P" subtitle:@"distance" latitude:latitude longitude:longitude canReceiveFocus:YES];
    
    UILabel *parkingSpotLabel = ((RoundedLabelMarkerView*)parkingSpot.view).label;
    parkingSpotLabel.backgroundColor = [UIColor darkGrayColor];
    parkingSpotLabel.textColor = [UIColor yellowColor];
    
    [sm3dar.map addAnnotation:parkingSpot];        
    
    [parkButton setTitle:BTN_TITLE_RESET_SPOT forState:UIControlStateNormal];
    [self setDropTargetHidden:YES];
    
    [self performSelector:@selector(zoomMapIn) withObject:nil afterDelay:0.66];
}

- (void) saveSpot
{
    PointOfInterest *poi = nil;

    if (parkingSpot)
    {
        NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:parkingSpot.coordinate.latitude], @"latitude",
                                    [NSNumber numberWithDouble:parkingSpot.coordinate.longitude], @"longitude",
                                    nil];
        
        poi = [[PointOfInterest alloc] initWithDictionary:properties];    
    }
    
    PREF_SAVE_OBJECT(PREF_KEY_LAST_POI, poi.dictionary);
    [poi release];
}

- (void) restoreSpot
{
    NSDictionary *properties = (NSDictionary*)PREF_READ_OBJECT(PREF_KEY_LAST_POI);
    NSLog(@"restoring: %@", properties);
    if (!properties)
        return;
    
    CLLocationDegrees latitude = [(NSNumber*)[properties objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [(NSNumber*)[properties objectForKey:@"longitude"] doubleValue];
    [self setParkingSpotLatitude:latitude longitude:longitude];
}

- (void) toggleParkingSpot
{
    if (parkingSpot)
    {
        // remove it
        [sm3dar removePointOfInterest:parkingSpot];
        self.parkingSpot = nil;
        [self setDropTargetHidden:NO];
        [parkButton setTitle:BTN_TITLE_SET_SPOT forState:UIControlStateNormal];
    }
    else
    {
        // drop a pin
        CLLocationCoordinate2D currentLoc = [sm3dar.map convertPoint:CGPointMake(160, 250)
                                                toCoordinateFromView:self.view];
        CLLocationDegrees lat = currentLoc.latitude;
        CLLocationDegrees lon = currentLoc.longitude;
        
        [self setParkingSpotLatitude:lat longitude:lon];
    }

	[self updatePointer];
    [self saveSpot];
}

- (BOOL) compassIsEnlarged
{
    return (compass.currentScale > 0.9);
}

- (void) enlargeCompass
{
    if ([self compassIsEnlarged])
        return;
    
    compass.paddingOffset = CGPointMake(COMPASS_PADDING_X_ENLARGED, COMPASS_PADDING_Y_ENLARGED);
    [compass toggleState];
}

- (void) shrinkCompass
{
    if (![self compassIsEnlarged])
        return;
    
    compass.paddingOffset = CGPointMake(COMPASS_PADDING_X_SHRUNK, COMPASS_PADDING_Y_SHRUNK);
    [compass toggleState];    
}

- (void) didShowMap 
{
    [self shrinkCompass];
    [self bringActiveScreenToFront];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    APP_DELEGATE.tabBarController.view.hidden = NO;
}

// Show the AR view
- (void) didHideMap 
{
    [self bringActiveScreenToFront];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    APP_DELEGATE.tabBarController.view.hidden = YES;
}

- (void) updatePointer
{
    if (!parkingSpot)
    {
        pointer.hidden = YES;
        return;
    }
    
    pointer.hidden = NO;
    
    Coord3D worldPoint = parkingSpot.worldPoint;
    CGFloat x = worldPoint.x;
    CGFloat y = worldPoint.y;
    CGFloat radians = atan2(x, y);
    
    [pointer rotate:radians duration:(POINTER_UPDATE_SEC)];
    [arrow pointAt:radiansToDegrees(radians)];    
}

- (void) updateHUD
{
    if (!compass)
        return;
    
    CGFloat radians;
    
    // Update instructions
    if (!instructions.hidden)
    {
        [instructions rotate:sm3dar.screenOrientationRadians duration:(POINTER_UPDATE_SEC*0.99)];  
    }
    
    // Update compass
    if (abs(lastHeading - sm3dar.trueHeading) < HEADING_DELTA_THRESHOLD)
    	return;

    lastHeading = sm3dar.trueHeading;

    radians = -degreesToRadians(lastHeading);
    [compass rotate:radians duration:(POINTER_UPDATE_SEC*0.99)];  
}

- (void) pointerWasTapped:(PointerView*)pointerView
{
    if ([self compassIsEnlarged])
        compass.paddingOffset = CGPointMake(COMPASS_PADDING_X_SHRUNK, COMPASS_PADDING_Y_SHRUNK);
    else
        compass.paddingOffset = CGPointMake(COMPASS_PADDING_X_ENLARGED, COMPASS_PADDING_Y_ENLARGED);

    [compass toggleState];
}

#pragma mark Background
- (SM3DAR_Fixture*) addFixtureWithView:(SM3DAR_PointView*)pointView
{
    // create point
    SM3DAR_Fixture *point = [[SM3DAR_Fixture alloc] init];
    
    // give point a view
    point.view = pointView;  
    
    // add point to 3DAR scene
    [[SM3DAR_Controller sharedController] addPointOfInterest:point];
    return [point autorelease];
}

- (void) addBackground
{
    SphereView *sphereView = [[SphereView alloc] initWithTextureNamed:@"sky2.png"];
    [self addFixtureWithView:sphereView];
    [sphereView release];
}

- (void) addGroundPlane
{
    GroundPlaneView *gpView = [[GroundPlaneView alloc] initWithTextureNamed:@"ground1_1024.jpg"];
    [self addFixtureWithView:gpView];
    [gpView release];
}

- (void) addArrow
{
    // Create the arrow view
    ArrowView *arrowView = [[[ArrowView alloc] initWithTextureNamed:@""] autorelease];
    arrowView.color = [UIColor yellowColor];

    // Create a fixture for the arrow
    self.arrow = [[[ArrowFixture alloc] initWithView:arrowView] autorelease];    
    [[SM3DAR_Controller sharedController] addPointOfInterest:arrow];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveArrow) userInfo:nil repeats:YES];
}

- (void) moveArrow
{    
    Coord3D c = [sm3dar ray:CGPointMake(160, 240)];
    CGFloat distance = 250.0;
    c.x *= distance;
    c.y *= distance;
    c.z *= distance;// * 0.95;
    self.arrow.worldPoint = c;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    ((ArrowView*)arrow.view).scalar += 1;
}

@end
