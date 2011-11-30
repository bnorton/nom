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
#import "FBConnect.h"
#import "NMFBModel.h"
#import "MKInfoPanel.h"
#import "current.h"

@implementation util

static AFHTTPClient *sharedClient = nil;
static NSOperationQueue *sharedQueue = nil;
static TTTOrdinalNumberFormatter *_ordinal_formatter;
static TTTLocationFormatter *_location_formatter;
static TTTTimeIntervalFormatter *_time_formatter;
static Facebook *_facebook;
static NSArray *_perms;
static NMFBModel *_fbmodel;
static SBJsonWriter *_writer;

static MKInfoPanel *info_panel;
static BOOL should_display_message;
static BOOL is_error_message;
static NSString *display_message;
static NSString *display_sub_message;


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
        NSLog(@"UTIL initialize");

        _fbmodel = [[NMFBModel alloc] init];
        _facebook = [[Facebook alloc] initWithAppId:FBAPPID andDelegate:_fbmodel];
        
        _facebook.accessToken = [currentUser getStringForKey:@"fb_access_token"];
        _facebook.expirationDate = [currentUser getObjectForKey:@"fb_expiration_date"];

        sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://justnom.it"]];
        sharedQueue = [[NSOperationQueue alloc] init];
        _ordinal_formatter = [[TTTOrdinalNumberFormatter alloc] init];
        _location_formatter = [[TTTLocationFormatter alloc] init];
        _time_formatter = [[TTTTimeIntervalFormatter alloc] init];
        _perms = [NSArray arrayWithObjects:PERMS];
        [_location_formatter setUnitSystem:TTTImperialSystem];
        _writer = [[SBJsonWriter alloc] init];
        
        info_panel = [[MKInfoPanel alloc] init];
        should_display_message = NO;
        is_error_message = NO;
        display_message = nil;
        display_sub_message = nil;
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

+ (NMFBModel *)fbmodel {
    return _fbmodel;
}

+ (Facebook *)facebook {
    return _facebook;
}
+ (NSArray *)perms {
    return _perms;
}

+ (SBJsonWriter *)JSONWriter {
    return _writer;
}

+ (void)showInfoInView:(UIView *)in_view isError:(BOOL)error message:(NSString *)message subMessage:(NSString *)sub {
    MKInfoPanelType type = error ? MKInfoPanelTypeError : MKInfoPanelTypeInfo;
    [MKInfoPanel showPanelInView:in_view type:type title:message subtitle:sub hideAfter:3.5];
}

+ (void)viewDidAppear:(UIView *)the_view {
    if (should_display_message) {
        should_display_message = NO;
        [util showInfoInView:the_view isError:is_error_message message:display_message subMessage:display_sub_message];
        display_message = nil;
        display_sub_message = nil;
    }
}

+ (void)shouldShowMessage:(NSString *)message subMessage:(NSString *)sub_message isError:(BOOL)error {
    display_message = message;
    display_sub_message = sub_message;
    should_display_message = YES;
    is_error_message = error;
}

@end
