//
//  Model.h
//  PubReader2
//
//  Created by P. Mark Anderson on 2/19/10.
//  © Copyright, Digimarc Corporation, USA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CODER_KEY_DICTIONARY @"CODER_KEY_DICTIONARY"

@interface Model : NSObject 
{
    NSMutableDictionary *dictionary;
}

@property (nonatomic, retain) NSMutableDictionary *dictionary;

+ (BOOL) getBoolFromString:(NSString*)value;
- (id) initWithDictionary:(NSDictionary *)otherDictionary;
- (NSString*) getString:(NSString*)key;

@end
