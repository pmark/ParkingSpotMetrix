/*
 *  Constants.h
 *  Parkar
 *
 *  Created by P. Mark Anderson on 5/7/10.
 *  Copyright 2010 Spot Metrix, Inc. All rights reserved.
 *
 */

#define PREF_SAVE_OBJECT(name, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:name]
#define PREF_READ_OBJECT(name) [[NSUserDefaults standardUserDefaults] objectForKey:name]
#define PREF_READ_ARRAY(name) (NSArray*)PREF_READ_OBJECT(name)
#define PREF_READ_DICTIONARY(name) (NSDictionary*)PREF_READ_OBJECT(name)
#define PREF_SAVE_BOOL(name, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:name]
#define PREF_READ_BOOL(name) [[NSUserDefaults standardUserDefaults] boolForKey:name]
#define PREF_EXISTS(name) ([[NSUserDefaults standardUserDefaults] objectForKey:name] != nil)

#define PREF_KEY_LAST_POI @"PREF_KEY_LAST_POI" 

#define RELEASE(object) \
{ \
	if(object)\
	{ \
		[object release];\
		object=nil; \
	} \
}

#define APP_DELEGATE ((ParkarAppDelegate*)[[UIApplication sharedApplication] delegate])
#define REV_GEOCODE_URL_FORMAT @"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true"

// Height of viewer above ground plane
#define GROUNDPLANE_ZPOS -80

