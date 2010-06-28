//
//  ParkarViewController.m
//  Parkar
//
//  Created by P. Mark Anderson on 5/7/10.
//  Copyright Spot Metrix, Inc 2010. All rights reserved.
//

#import "ParkarViewController.h"
#import "Constants.h"
#import "RoundedLabelMarkerView.h"
#import "PointOfInterest.h"
#import "SphereBackgroundView.h"
#import "GroundPlaneView.h"
#import "ArrowView.h"
#import "ParkarAppDelegate.h"
#import "NSUserDefaults+Database.h"
#import "ParkingSpot.h"
#import "ParkingSpotPOI.h"
#import "NSString+SBJSON.h"
#import "NSUserDefaults+Database.h"

extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);

#define BTN_TITLE_SET_SPOT @"Park Here"
#define BTN_TITLE_RESET_SPOT @"Reset Parking Spot"

#define POINTER_UPDATE_SEC 0.5
#define STATUS_UPDATE_SEC 1.0
#define HEADING_DELTA_THRESHOLD 0.001

#define COMPASS_PADDING_X_SHRUNK 10
#define COMPASS_PADDING_Y_SHRUNK 290
#define COMPASS_PADDING_X_ENLARGED 10
#define COMPASS_PADDING_Y_ENLARGED 108 //63

#define INSTRUCTIONS_PADDING_X 0
#define INSTRUCTIONS_PADDING_Y 85

#define NEAR_CLIP_METERS 1
#define FAR_CLIP_METERS 800000
#define FAR_AWAY_METERS 1000
#define NEARBY_METERS 35
#define ARROW_ORBIT_DISTANCE 25.0
#define ARROW_SIZE_SCALAR 0.08
#define ARROW_MOVEMENT_TIMER_INTERVAL 0.005
#define HEADER_BORDER_WIDTH 2

#define STATUS_LABEL_TEXT_NO_SPOT @"Move the map and tap \"Park Here\"\nto drop a pin."
#define STATUS_LABEL_TEXT_WITH_SPOT @"Parking spot is %@ away\n(%@ as the crow flies)"

@implementation ParkarViewController

@synthesize screen1;
@synthesize dropTarget;
@synthesize toolbar;
@synthesize sm3darView;
@synthesize parkButton;
@synthesize parkingSpot;
@synthesize pointer;
@synthesize compass;
@synthesize instructions;
@synthesize arrow;
@synthesize address;
@synthesize sphereBackground;
@synthesize groundplane;
@synthesize statusLabel;
@synthesize locationUpdatedAt;

- (void)dealloc 
{
    RELEASE(screen1);
    RELEASE(dropTarget);
    RELEASE(sm3darView);
    RELEASE(toolbar);
    RELEASE(parkButton);
    RELEASE(parkingSpot);
    RELEASE(pointer);
    RELEASE(compass);
    RELEASE(instructions);
    RELEASE(hudTimer);
    RELEASE(statusTimer);
    RELEASE(address);
    RELEASE(sphereBackground);
    RELEASE(groundplane);
    RELEASE(statusLabel);
    RELEASE(locationUpdatedAt);
    [super dealloc];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        lastHeading = 0.0;
        self.address = nil;
    }
    return self;
}

- (SM3DAR_Fixture*) addLabelFixture:(NSString*)title subtitle:(NSString*)subtitle coord:(Coord3D)coord
{
    //    RoundedLabelMarkerView *v = [[RoundedLabelMarkerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    ArrowView *v = [[ArrowView alloc] initWithTextureNamed:@""];
    v.color = [UIColor blueColor];
//    v.title = title;
//    v.subtitle = subtitle;
//SM3DAR_Fixture *fixture = [self addFixtureWithView:v];
    ArrowFixture *fixture = [self addArrowFixture:v];
    fixture.worldPoint = coord;
    [v release];

    return fixture;
}

- (SM3DAR_PointOfInterest*) addPOI:(NSString*)title subtitle:(NSString*)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon canReceiveFocus:(BOOL)canReceiveFocus 
{
    SM3DAR_PointOfInterest *poi = [[sm3dar initPointOfInterest:lat 
                                                     longitude:lon 
                                                      altitude:0 
                                                         title:title 
                                                      subtitle:subtitle 
                                               markerViewClass:[RoundedLabelMarkerView class] 
                                                    properties:nil] autorelease];    
    poi.canReceiveFocus = canReceiveFocus;
    [sm3dar addPointOfInterest:poi];
    [sm3dar.map addAnnotation:poi];
    return poi;
}

- (void) zoomMapIn
{
    
    // TODO: 3DAR may not be initialized yet, so don't zoom.
    
    if (parkingSpot)
    {
        [sm3dar zoomMapToFitPointsIncludingUserLocation:YES];
    }
    else
    {
        MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
        region.center = sm3dar.map.userLocation.coordinate;
        region.span.longitudeDelta = 0.002f;
        region.span.latitudeDelta = 0.002f;
        [sm3dar.map setRegion:region animated:YES];
    }
}

- (void) addDirectionBillboards 
{
    // Add compass points.
//    CLLocationCoordinate2D currentLoc = [sm3dar currentLocation].coordinate;
//    CLLocationDegrees lat=currentLoc.latitude;
//    CLLocationDegrees lon=currentLoc.longitude;
    
    Coord3D north, south, east, west = sm3dar.currentPosition;
    north.x += 1000;
    south.x -= 1000;
    east.y += 1000;
    west.y -= 1000;
    
    [self addLabelFixture:@"N" subtitle:@"" coord:north];
    [self addLabelFixture:@"S" subtitle:@"" coord:south];
    [self addLabelFixture:@"E" subtitle:@"" coord:east];
    [self addLabelFixture:@"W" subtitle:@"" coord:west];
}

- (void) loadPointsOfInterest
{
    [self addBackground];
    [self addGroundPlane];
	[self addArrow];
    [self restoreSpot];
	[self updatePointer];
    [self updateStatusLabel];

    [self performSelector:@selector(zoomMapIn) withObject:nil afterDelay:2.0];

    [self bringActiveScreenToFront];
    normal3darRect = sm3dar.view.frame;
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

    CGRect f = header.frame;
    f.origin.y = -HEADER_BORDER_WIDTH;
    header.frame = f;   
    
    CALayer *l = [header layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    [l setBorderWidth:HEADER_BORDER_WIDTH];
    [l setBorderColor:[[UIColor blackColor] CGColor]];    
    
    hudTimer = [NSTimer scheduledTimerWithTimeInterval:POINTER_UPDATE_SEC target:self selector:@selector(updateHUD) userInfo:nil repeats:YES];
    statusTimer = [NSTimer scheduledTimerWithTimeInterval:STATUS_UPDATE_SEC target:self selector:@selector(updateStatusLabel) userInfo:nil repeats:YES];
}

- (void) init3dar
{
    sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.delegate = self;
    sm3dar.nearClipMeters = NEAR_CLIP_METERS;
    sm3dar.farClipMeters = FAR_CLIP_METERS;
    sm3dar.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    sm3dar.view.backgroundColor = [UIColor blackColor];
    sm3dar.wantsFullScreenLayout = NO;
    sm3dar.mapZoomPadding = 1.9;
    
	[self.view addSubview:sm3dar.view];
    self.wantsFullScreenLayout = NO;
}

- (void) viewDidLoad
{
    NSLog(@"\n\nPVC: viewDidLoad\n\n");
    [super viewDidLoad];

    [self init3dar];
    [self buildScreen1];        
    [self buildHUD];
    [self bringActiveScreenToFront];

    [self.view bringSubviewToFront:header];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Resuming 3DAR");
	[sm3dar resume];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"Suspending 3DAR");
	[sm3dar suspend];
}

- (void) didReceiveMemoryWarning 
{
    NSLog(@"\n\nPVC: didReceiveMemoryWarning\n\n");
    
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    NSLog(@"\n\nPVC: viewDidUnload\n\n");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) setToolbarHidden:(BOOL)hide
{
    if ((hide && headerHidden) || (!hide && !headerHidden))
        return;

    CGRect f = header.frame;
    f.origin.y = (hide ? -44 : 0) - HEADER_BORDER_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    header.frame = f;
    [UIView commitAnimations];
    headerHidden = hide;
}

- (void) bringActiveScreenToFront
{
    if (sm3dar.mapIsVisible)
    {
        screen1.hidden = NO;
        instructions.hidden = YES;
        dropTarget.hidden = NO;        
        [self setToolbarHidden:NO];
    }
    else 
    {
        screen1.hidden = YES;
        instructions.hidden = (parkingSpot != nil);
        dropTarget.hidden = YES;
        [self setToolbarHidden:YES];
    }

    [self.view bringSubviewToFront:screen1];
}

- (NSString*) buildStatusLabel
{
    NSString *text; 
    
    if (parkingSpot)
    {
        CGFloat rangeMeters = [parkingSpot distanceInMetersFromCurrentLocation];
        NSInteger rangeBlocks = round(rangeMeters / 80.0);
        CGFloat rangeFeet = rangeMeters * 3.2808399;
        
        NSString *away;
        if (rangeBlocks < 1.0)
        {
            away = @"less than a block";
        }
        else
        {
            away = [NSString stringWithFormat:@"about %i block%@",
                    rangeBlocks, 
                    ((rangeBlocks == 1) ? @"" : @"s")];
        }
        
        NSString *prettyRange;
        if (rangeMeters < 1609.344)
        {
            // less than 1 mile
            prettyRange = [NSString stringWithFormat:@"%.0fft or %.0fm", 
                           rangeFeet, rangeMeters];
        }
        else 
        {
            prettyRange = [NSString stringWithFormat:@"%.1fmi or %.1fkm", 
                           rangeFeet/5280.0, rangeMeters/1000.0];
        }

        text = [NSString stringWithFormat:STATUS_LABEL_TEXT_WITH_SPOT, 
                            away,
                            prettyRange];
    }
    else
    {
        text = STATUS_LABEL_TEXT_NO_SPOT;
    }
    
    //Coord3D cam = sm3dar.currentPosition;
    //text = [NSString stringWithFormat:@"cam: (%.0f, %.0f, %.0f)", cam.x, cam.y, cam.z];
    return text;
}

- (void) updateStatusLabel
{    
    NSString *text = @"";

    if (address)
    {
        //        text = [text stringByAppendingFormat:@"\n%@", address];
        text = [NSString stringWithFormat:@"%@\n", address];
    }
    
    text = [text stringByAppendingString:[self buildStatusLabel]];
    
    if (parkingSpot) 
    {
        NSInteger secSinceUpdate = -(NSInteger)[locationUpdatedAt timeIntervalSinceNow];
        NSString *status = [NSString stringWithFormat:@"\nAccuracy was %.0fm %i second%@ ago",
                            [sm3dar.currentLocation horizontalAccuracy],
                            secSinceUpdate, 
                            (secSinceUpdate == 1) ? @"" : @"s"];
        text = [text stringByAppendingString:status];
    }

    statusLabel.text = text;
    
    if (!sm3dar.mapIsVisible)
    {
        CGRect f = header.frame;

        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            // hide header    
            f.origin.y = -f.size.height;
        }
        else
        {
            f.origin.y = -44 - HEADER_BORDER_WIDTH;
        }
        
        [UIView beginAnimations:nil context:nil];
        header.frame = f;
        [UIView commitAnimations];
    }
}

- (void) locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation 
{
//    [self addPOI:[NSString stringWithFormat:@"%i",poiCount++] 
//        subtitle:@""
//        latitude:newLocation.coordinate.latitude
//       longitude:newLocation.coordinate.longitude
// canReceiveFocus:NO];

    self.locationUpdatedAt = [NSDate date];
    
    if (parkingSpot)
    {
        [self updatePointer];
    }
    else if (dropTarget.alpha < 0.1)
    {
        [self performSelector:@selector(showDropTarget) withObject:nil afterDelay:2.0];
    }

    [self updateStatusLabel];
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

- (void) reverseGeocode
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"reverse geocoding...");
    NSString *reverseGeocoder = [NSString stringWithFormat:
                                 @"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",
                                 self.parkingSpot.coordinate.latitude, 
                                 self.parkingSpot.coordinate.longitude];
	NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:reverseGeocoder] 
                                                  encoding:NSUTF8StringEncoding error:nil];    
    id data = [response JSONValue];
    if (!data || [data count] == 0) return;
    if ([data isKindOfClass:[NSArray class]]) data = [data objectAtIndex:0];
    if (![data isKindOfClass:[NSDictionary class]]) return;
    data = [data objectForKey:@"results"]; if (!data || [data count] == 0) return;
    if ([data isKindOfClass:[NSArray class]]) data = [data objectAtIndex:0];
    if (![data isKindOfClass:[NSDictionary class]]) return;

    //NSLog(@"%@", data);
    //data = [data objectForKey:@"formatted_address"]; if (!data) return;

    data = [data objectForKey:@"address_components"]; if (!data) return;
    // array with hash
    NSString *streetNumber = [[(NSArray*)data objectAtIndex:0] objectForKey:@"short_name"];
    NSString *streetName = [[(NSArray*)data objectAtIndex:1] objectForKey:@"short_name"];
    self.address = [NSString stringWithFormat:@"%@ %@", streetNumber, streetName];
    
    //NSLog(@"address: %@", address);
	[self updateStatusLabel];    
    self.parkingSpot.title = address;
    
    [pool release];
}

- (void) setParkingSpotLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    if (parkingSpot)
    	[sm3dar removePointOfInterest:parkingSpot];    
    
    self.parkingSpot = [ParkingSpotPOI parkingSpotPOIWithLatitude:latitude longitude:longitude];    
//    NSLog(@"new spot at %.2f, %.2f: %@", latitude, longitude, parkingSpot);
    
    [sm3dar addPointOfInterest:parkingSpot];
    [sm3dar.map addAnnotation:parkingSpot];        
    
    parkButton.title = BTN_TITLE_RESET_SPOT;
    parkButton.style = UIBarButtonItemStyleDone;
    [self setDropTargetHidden:YES];
    
    [self performSelector:@selector(zoomMapIn) withObject:nil afterDelay:0.66];

    self.address = nil;
    [self performSelectorInBackground:@selector(reverseGeocode) withObject:nil];
}

- (BOOL) parkingSpotIsValid
{
    return (parkingSpot && parkingSpot.coordinate.latitude != 0.0 && parkingSpot.coordinate.longitude != 0.0);
}

- (void) saveSpot
{
    if (![self parkingSpotIsValid])
        return;

    PointOfInterest *poi = nil;

    poi = [[PointOfInterest alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithDouble:parkingSpot.coordinate.latitude], @"latitude",
                                                       [NSNumber numberWithDouble:parkingSpot.coordinate.longitude], @"longitude",
                                                       nil]];
    
    PREF_PUSH(poi.dictionary, PREF_KEY_SPOT_HISTORY, HISTORY_CAPACITY);
    PREF_SAVE_OBJECT(PREF_KEY_INDEX_OF_ACTIVE_SPOT, [NSNumber numberWithInt:0]);
    [poi release];
}

- (void) restoreSpot
{
    NSArray *history = PREF_READ_ARRAY(PREF_KEY_SPOT_HISTORY);

    NSNumber *index = (NSNumber*)PREF_READ_OBJECT(PREF_KEY_INDEX_OF_ACTIVE_SPOT);
    if (!index) 
        return;

    NSDictionary *properties = (NSDictionary*)[history objectAtIndex:[index intValue]];
    //NSLog(@"Restoring parking spot: %@", properties);
    if (!properties)
        return;
    
    CLLocationDegrees latitude = [(NSNumber*)[properties objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [(NSNumber*)[properties objectForKey:@"longitude"] doubleValue];
    
    if (latitude == 0.0 || longitude == 0.0)
        return;
    
    [self setParkingSpotLatitude:latitude longitude:longitude];
}

- (IBAction) toggleParkingSpot
{
    if (parkingSpot)
    {
        // remove it
        [sm3dar removePointOfInterest:parkingSpot];
        self.parkingSpot = nil;
        [parkingSpot release];
        PREF_SAVE_OBJECT(PREF_KEY_INDEX_OF_ACTIVE_SPOT, nil);        
        
        [self setDropTargetHidden:NO];
        parkButton.title = BTN_TITLE_SET_SPOT;
        parkButton.style = UIBarButtonItemStyleBordered;
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
    self.address = nil;
    [self updateStatusLabel];
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
    //    APP_DELEGATE.tabBarController.view.hidden = NO;
}

// Show the AR view
- (void) didHideMap 
{
    [self bringActiveScreenToFront];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    APP_DELEGATE.tabBarController.view.hidden = YES;
}

- (ArrowView*) parkingSpotView
{
    return ((ArrowView*)parkingSpot.view);
}

- (void) updatePointer
{
    if (!parkingSpot)
    {
        arrow.view.alpha = 0.0;
        pointer.hidden = YES;
        return;
    }
    
    CGFloat rangeMeters = [parkingSpot distanceInMetersFromCurrentLocation];

    if (rangeMeters > NEARBY_METERS)
    {
        arrow.view.alpha = 1.0;
        [self parkingSpotView].alpha = 1.0;
        sphereBackground.view.alpha = 1.0;
        groundplane.view.alpha = 1.0;

        if (sm3dar.camera)
        {
        	[sm3dar stopCamera];
//            CGRect f = sm3dar.view.frame;
//            f.size.height = f.size.height - 20;
            [sm3dar setFrame:normal3darRect];
        }
        
        if (rangeMeters > FAR_AWAY_METERS)
        {
            [[self parkingSpotView] setDistantStyle];
        }
        else
        {
            [[self parkingSpotView] setMidrangeStyle];
        }
    }
    else
    {
        //[[self parkingSpotView] setNearbyStyle];
        arrow.view.alpha = 1.0;
        [self parkingSpotView].alpha = 0.0;
        sphereBackground.view.alpha = 0.0;
        groundplane.view.alpha = 0.0;
        
        if (!sm3dar.camera)
        {
            [sm3dar startCamera];
            CGRect f = sm3dar.view.frame;
            f.size.height = f.size.height + 20;
            [sm3dar setFrame:f];
        }
    }

    pointer.hidden = NO;

    Coord3D anchorPosition = [SM3DAR_Controller worldCoordinateFor:sm3dar.currentLocation];
    //Coord3D anchorPosition = [sm3dar cameraPosition];    
    Coord3D worldPoint = parkingSpot.worldPoint;
    
    CGFloat dx = worldPoint.x - anchorPosition.x;
    CGFloat dy = worldPoint.y - anchorPosition.y;
    CGFloat radians = atan2(dx, dy);
    
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

- (ArrowFixture*) addArrowFixture:(ArrowView*)arrowView
{
    // create point
    ArrowFixture *a = [[ArrowFixture alloc] initWithView:arrowView];
    
    // add point to 3DAR scene
    [[SM3DAR_Controller sharedController] addPointOfInterest:a];
    return [a autorelease];
}

- (void) addBackground
{
    SphereBackgroundView *sphereView = [[SphereBackgroundView alloc] initWithTextureNamed:@"sky2.png"];
    self.sphereBackground = [self addFixtureWithView:sphereView];
    [sphereView release];
}

- (void) addGroundPlane
{
    GroundPlaneView *gpView = [[GroundPlaneView alloc] initWithTextureNamed:@"ground1_1024.jpg"];
    self.groundplane = [self addFixtureWithView:gpView];
    [gpView release];
}

- (void) addArrow
{
    // Create the arrow view
    ArrowView *arrowView = [[[ArrowView alloc] initWithTextureNamed:@""] autorelease];
    arrowView.color = [UIColor yellowColor];
    arrowView.sizeScalar = ARROW_SIZE_SCALAR;

    // Create a fixture for the arrow
    self.arrow = [[[ArrowFixture alloc] initWithView:arrowView] autorelease];    
    [[SM3DAR_Controller sharedController] addPointOfInterest:arrow];
    
    [NSTimer scheduledTimerWithTimeInterval:ARROW_MOVEMENT_TIMER_INTERVAL target:self selector:@selector(moveArrow) userInfo:nil repeats:YES];

    Coord3D wp = [sm3dar cameraPosition];
    wp.x += ARROW_ORBIT_DISTANCE;
    self.arrow.worldPoint = wp;
}

- (void) moveArrow
{    
    Coord3D c = [sm3dar ray:CGPointMake(160, 205)];
    CGFloat distance = ARROW_ORBIT_DISTANCE;
    c.x *= distance;
    c.y *= distance;
    c.z *= distance * 0.95;

    Coord3D arrowPosition = [sm3dar cameraPosition];
    arrowPosition.x += c.x;
    arrowPosition.y += c.y;
    arrowPosition.z += c.z;
    self.arrow.worldPoint = arrowPosition;
}

- (IBAction) zoom
{
	[self zoomMapIn];    
}

@end
