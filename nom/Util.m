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
static TTTArrayFormatter * _array_formatter;
static NSDateFormatter *_date_formatter;

static Facebook *_facebook;
static NSArray *_perms;
static NMFBModel *_fbmodel;
static SBJsonWriter *_writer;

static MKInfoPanel *info_panel;
static BOOL should_display_message;
static BOOL is_error_message;
static NSString *display_message;
static NSString *display_sub_message;

static UIView *currently_set_view;

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
        _array_formatter = [[TTTArrayFormatter alloc] init];
        _date_formatter = [[NSDateFormatter alloc] init];
        
        _perms = [NSArray arrayWithObjects:PERMS];
        [_location_formatter setUnitSystem:TTTImperialSystem];
        _writer = [[SBJsonWriter alloc] init];
        
        info_panel = [[MKInfoPanel alloc] init];
        should_display_message = NO;
        is_error_message = NO;
        display_message = nil;
        display_sub_message = nil;
        
        currently_set_view = nil;
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

+ (TTTArrayFormatter *)format_array {
    return _array_formatter;
}

+ (NSString *)timeAgoFromRailsString:(NSString *)str {
    @try { 
        // "created_at" = "2011-12-13T21:12:19Z"
        [_date_formatter setDateFormat:RAILS_TIME_FORMAT];
        NSDate *date = [_date_formatter dateFromString:str]; 
        return [_time_formatter stringForTimeIntervalFromDate:[NSDate date] toDate:date];
    } @catch (NSException *ex) {;}
    return nil;
}

+ (NSDate *)dateFromRailsString:(NSString *)str {
    @try { 
        // "created_at" = "2011-12-13T21:12:19Z"
        [_date_formatter setDateFormat:RAILS_TIME_FORMAT];
        return [_date_formatter dateFromString:str]; 
    } @catch (NSException *ex) {;}
    return nil;
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

+ (void)showInfoInView:(UIView *)in_view message:(NSString *)message {
    [self showInfoInView:in_view isError:NO message:message subMessage:nil];
}

+ (void)showErrorInView:(UIView *)in_view message:(NSString *)message {
    [self showInfoInView:in_view isError:YES message:message subMessage:nil];
}

+ (void)showInfoInView:(UIView *)in_view isError:(BOOL)error message:(NSString *)message subMessage:(NSString *)sub {
    MKInfoPanelType type = error ? MKInfoPanelTypeError : MKInfoPanelTypeInfo;
    [MKInfoPanel showPanelInView:in_view type:type title:message subtitle:sub hideAfter:3.25];
}

+ (MBProgressHUD *)showHudInView:(id)view {
    if (view == nil) { return nil; }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    return hud;
}

+ (NSString *)base36Encode:(NSInteger)to_encode {
    NSString *alpha = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *result = @"";
    int mod;
    while (to_encode != 0) {
        mod = to_encode % 36;
        to_encode = to_encode / 36;
    
        result = [NSString stringWithFormat:@"%c%@", [alpha characterAtIndex:mod], result];
    }
    return result;
}

+ (NSString *)publicationToken {
    int r = abs((int)arc4random() % (int)pow(36, 10));
    return [util base36Encode:r];
}

+ (void)viewDidAppear:(UIView *)the_view {
    @synchronized (self) {
        if ( ! [currently_set_view isEqual:the_view]) {
            currently_set_view = the_view;
        }
        if (should_display_message) {
            should_display_message = NO;
            [util showInfoInView:the_view isError:is_error_message message:display_message subMessage:display_sub_message];
            display_message = nil;
            display_sub_message = nil;
        }
    }
}

+ (void)shouldShowMessage:(NSString *)message subMessage:(NSString *)sub_message isError:(BOOL)error {
    @synchronized (self) {
        display_message = message;
        display_sub_message = sub_message;
        should_display_message = YES;
        is_error_message = error;
    }
    /* test to see if we have a good handle to a view */
    if (currently_set_view != nil && currently_set_view.window != nil) {
        [util viewDidAppear:currently_set_view];
    }
}

+ (NSString *)textForThumb:(NSInteger)value {
    if (value == 1) {
        return @"a thumb up";
    } else if (value == 2) {
        return @"meh";
    }
    return nil;
}

@end
