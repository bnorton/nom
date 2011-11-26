//
//  util.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "util.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#import "current.h"

@implementation util

static AFHTTPClient *sharedClient = nil;
static NSOperationQueue *sharedQueue = nil;
static TTTOrdinalNumberFormatter *_ordinal_formatter;
static TTTLocationFormatter *_location_formatter;
static TTTTimeIntervalFormatter *_time_formatter;

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    return self;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        NSLog(@"UTIL initialize");
        initialized = YES;
        sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://justnom.it"]];
        sharedQueue = [[NSOperationQueue alloc] init];
        _ordinal_formatter = [[TTTOrdinalNumberFormatter alloc] init];
        _location_formatter = [[TTTLocationFormatter alloc] init];
        _time_formatter = [[TTTTimeIntervalFormatter alloc] init];
    }
}

/**
 * Methods that wrap the parameters themselves
 */

+ (AFHTTPClient *)http_client {
    return sharedClient;
}

+(NSOperationQueue *)queue {
    return sharedQueue;
}

+ (TTTLocationFormatter *)format_location {
    return _location_formatter;
}

+ (TTTOrdinalNumberFormatter *)format_ordinal {
    return _ordinal_formatter;
}

+ (TTTTimeIntervalFormatter *)format_time {
    return _time_formatter;
}

+ (NSString *)distanceFromLat:(CGFloat)lat Long:(CGFloat)lng {
    
}

@end
