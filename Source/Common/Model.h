//
//  Model.h
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
