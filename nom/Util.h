//
//  util.h
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MKBlockAdditions.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "MKInfoPanel.h"

#import "currentData.h"
#import "currentLocation.h"
#import "currentUser.h"

#import "NMHTTPClient.h"

#define HTTPClient [util http_client]
#define HTTPQueue [util queue]

@class AFHTTPClient;

@interface util : NSObject

+(AFHTTPClient *)http_client;
+(NSOperationQueue *)queue;

@end
