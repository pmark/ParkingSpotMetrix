/*
 *  Constants.h
 *  WharCar
 *
 *  Created by P. Mark Anderson on 5/7/10.
 *  Copyright 2010 Spot Metrix, Inc. All rights reserved.
 *
 */

#define CONFIG_STRING(name) [PubReaderSession stringForConfigItem:name]
#define CONFIG_BOOL(name) [PubReaderSession boolForConfigItem:name]
#define CONFIG_INTEGER(name) [PubReaderSession integerForConfigItem:name]
#define CONFIG_DOUBLE(name) [PubReaderSession doubleForConfigItem:name]

#define PREF_SAVE_OBJECT(name, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:name]
#define PREF_READ_OBJECT(name) [[NSUserDefaults standardUserDefaults] objectForKey:name]
#define PREF_READ_ARRAY(name) (NSArray*)PREF_READ_OBJECT(name)
#define PREF_READ_DICTIONARY(name) (NSDictionary*)PREF_READ_OBJECT(name)
#define PREF_SAVE_BOOL(name, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:name]
#define PREF_READ_BOOL(name) [[NSUserDefaults standardUserDefaults] boolForKey:name]
#define PREF_EXISTS(name) ([[NSUserDefaults standardUserDefaults] objectForKey:name] != nil)


#define RELEASE(object) \
{ \
	if(object)\
	{ \
		[object release];\
		object=nil; \
	} \
}
