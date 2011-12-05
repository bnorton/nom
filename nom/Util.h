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

#import "NMHTTPClient.h"

#import "TTTOrdinalNumberFormatter.h"
#import "TTTLocationFormatter.h"
#import "TTTTimeIntervalFormatter.h"

#import "Facebook.h"
#import "NMFBModel.h"
#import "JSON.h"

#define HTTPClient [util http_client]
#define HTTPQueue [util queue]

#define FBAPPID  @"204823436250707"
#define FBSECRET @"c9b05af2f817dcd39ef53e49ab44265c"

#define PERMS @"user_checkins", @"publish_stream", @"offline_access", @"friends_location", @"email", nil

@class AFHTTPClient;

@interface util : NSObject

+ (AFHTTPClient *)http_client;
+ (NSOperationQueue *)queue;

+ (TTTLocationFormatter *)format_location;
+ (TTTOrdinalNumberFormatter *)format_ordinal;
+ (TTTTimeIntervalFormatter *)format_time;
+ (NSString *)timeAgoFromRailsString:(NSString *)str;

+ (NMFBModel *)fbmodel;
+ (Facebook *)facebook;
+ (NSArray *)perms;

+ (SBJsonWriter *)JSONWriter;

+ (NSString *)textForThumb:(NSInteger)value;

+ (void)showInfoInView:(UIView *)in_view message:(NSString *)message;
+ (void)showErrorInView:(UIView *)in_view message:(NSString *)message;
+ (void)showInfoInView:(UIView *)in_view isError:(BOOL)error message:(NSString *)message subMessage:(NSString *)sub;

+ (void)shouldShowMessage:(NSString *)message subMessage:(NSString *)sub_message isError:(BOOL)error;
+ (void)viewDidAppear:(UIView *)the_view;

@end
