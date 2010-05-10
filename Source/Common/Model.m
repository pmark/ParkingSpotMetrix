//
//  Model.m
//

#import "Model.h"

@implementation Model

@synthesize dictionary;

- (id)init
{
    if (self = [super init]) 
    {	
        self.dictionary = [NSMutableDictionary dictionary];
    }
	return self;
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self = [super init]) 
    {	
        if (otherDictionary)
            self.dictionary = [otherDictionary mutableCopy];
        else
            self.dictionary = [NSMutableDictionary dictionary];
    }
	return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder
{    
    [encoder encodeObject:dictionary forKey:CODER_KEY_DICTIONARY];
}

- (id) initWithCoder:(NSCoder*)decoder
{
    self.dictionary = [decoder decodeObjectForKey:CODER_KEY_DICTIONARY];
    return self;
}

- (void) dealloc 
{
  [dictionary release];
  [super dealloc];
}

- (NSString*) getString:(NSString*)key 
{
  NSString *value = [self.dictionary objectForKey:key];
  if (![value isKindOfClass:[NSString class]]) 
  {
    return nil;
  }
  // clean up string
  return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
}

// Return NO if given string is empty or "false" (case insensitive)
+ (BOOL) getBoolFromString:(NSString*)value 
{
  if (value == nil || [value isEqualToString:@""] ||[value isEqualToString:@"0"] || [[value lowercaseString] isEqualToString:@"false"] ) 
  {
    return NO;
  } 
  else 
  {
    return YES;
  }
}

@end
