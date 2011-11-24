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


@implementation util

static AFHTTPClient *sharedClient = nil;
static NSOperationQueue *sharedQueue = nil;

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
        initialized = YES;
        sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://justnom.it"]];
        sharedQueue = [[NSOperationQueue alloc] init];
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

@end
