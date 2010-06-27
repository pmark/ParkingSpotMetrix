//
//  NSUserDefaults+Database.h
//  Parkar
//
//  Created by P. Mark Anderson on 5/24/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//


#define PREF_EXISTS(name) ([[NSUserDefaults standardUserDefaults] objectForKey:name] != nil)
#define PREF_SAVE_OBJECT(name, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:name]
#define PREF_READ_OBJECT(name) [[NSUserDefaults standardUserDefaults] objectForKey:name]
#define PREF_READ_ARRAY(name) (NSArray*)PREF_READ_OBJECT(name)
#define PREF_READ_DICTIONARY(name) (NSDictionary*)PREF_READ_OBJECT(name)
#define PREF_SAVE_BOOL(name, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:name]
#define PREF_READ_BOOL(name) [[NSUserDefaults standardUserDefaults] boolForKey:name]
#define PREF_READ_BOOL_DEFAULT(name, value) (PREF_EXISTS(name) ? PREF_READ_BOOL(name) : value)
#define PREF_SAVE_INTEGER(name, value) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:name]
#define PREF_READ_INTEGER(name) [[NSUserDefaults standardUserDefaults] integerForKey:name]
#define PREF_READ_INTEGER_DEFAULT(name, value) (PREF_EXISTS(name) ? PREF_READ_INTEGER(name) : value)
#define PREF_PUSH(value, name, max) [[NSUserDefaults standardUserDefaults] addItemToTopOfArray:value key:name maximum:max]


@interface NSUserDefaults (Database)

@end
