/*
 *  Constants.h
 *  ParkingSpotMetrix
 *
 *  Created by P. Mark Anderson on 5/7/10.
 *  Copyright 2010 Spot Metrix, Inc. All rights reserved.
 *
 */

#define PREF_KEY_SPOT_HISTORY @"PREF_KEY_SPOT_HISTORY" 
#define PREF_KEY_INDEX_OF_ACTIVE_SPOT @"PREF_KEY_INDEX_OF_ACTIVE_SPOT" 
#define HISTORY_CAPACITY 25

#define RELEASE(object) \
{ \
	if(object)\
	{ \
		[object release];\
		object=nil; \
	} \
}

#define APP_DELEGATE ((ParkingSpotMetrixAppDelegate*)[[UIApplication sharedApplication] delegate])
#define REV_GEOCODE_URL_FORMAT @"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true"

// Height of viewer above ground plane
#define GROUNDPLANE_ZPOS -80

