//
//  activityCell.m
//  nom
//
//  Created by Brian Norton on 12/1/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "activityCell.h"
#include "UILabel+frame.h"
#import "Util.h"

@implementation activityCell

@synthesize location_nid, user_nid;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 21)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [title setLineBreakMode:UILineBreakModeTailTruncation];
    [title setNumberOfLines:0];
    [title setTextAlignment:UITextAlignmentLeft];
    [title setTextColor:[UIColor darkGrayColor]];

    text = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, 300, 18)];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setFont:[UIFont fontWithName:@"TrebuchetMS" size:13]];
    [text setLineBreakMode:UILineBreakModeTailTruncation];
    [text setNumberOfLines:0];
    [text setTextAlignment:UITextAlignmentLeft];
    [text setTextColor:[UIColor darkGrayColor]];

    when = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 300, 18)];
    [when setBackgroundColor:[UIColor clearColor]];
    [when setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [when setAdjustsFontSizeToFitWidth:YES];
    [when setMinimumFontSize:8];
    [when setLineBreakMode:UILineBreakModeTailTruncation];
    [when setNumberOfLines:1];
    [when setTextAlignment:UITextAlignmentLeft];
    [when setTextColor:[UIColor darkGrayColor]];

    distance = [[UILabel alloc] initWithFrame:CGRectMake(10, 61, 300, 18)];
    [distance setBackgroundColor:[UIColor clearColor]];
    [distance setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [distance setAdjustsFontSizeToFitWidth:YES];
    [distance setMinimumFontSize:8];
    [distance setLineBreakMode:UILineBreakModeTailTruncation];
    [distance setNumberOfLines:1];
    [distance setTextAlignment:UITextAlignmentLeft];
    [distance setTextColor:[UIColor darkGrayColor]];

    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    location_nid = @"";
    user_nid = @"";    

    [self addSubview:title];
    [self addSubview:text];
    [self addSubview:when];
    [self addSubview:distance];
    
    return self;
}

- (void)setupCommon:(NSDictionary *)common {
    location_nid = [common objectForKey:@"location_nid"];
    @try {
        NSString *city = [common objectForKey:@"city"];
        distance.text = [NSString stringWithFormat:@"from %@", city];
    } @catch (NSException *ex) {
        distance.text = [common objectForKey:@"city"];
    }
}

- (CGFloat)setupForThumb:(NSDictionary *)thumb isMocked:(BOOL)mock {
    NSDictionary *location = [thumb objectForKey:@"location"];
    title.text = [NSString stringWithFormat:@"%@ says %@", [thumb objectForKey:@"name"], 
                  [NSString stringWithFormat:@"%@ is %@", [location objectForKey:@"name"],
                   [util textForThumb:[[thumb objectForKey:@"value"] integerValue]]]];
    [title newFrameForText:title.text];
    text.text = @"";
    
    when.text = [util timeAgoFromRailsString:[thumb objectForKey:@"created_at"]];
    [self setupCommon:location];
    
    user_nid = [thumb objectForKey:@"user_nid"];
}

- (CGFloat)setupForRecommendation:(NSDictionary *)recom isMocked:(BOOL)mock {
    CGFloat height = 19;
    
    NSString *lname = [recom objectForKey:@"location_name"];
    NSString *uname = [recom objectForKey:@"user_name"];
    NSString *str = nil;
    
    if ([lname length] > 0 ) {
        if ([uname length] > 0) {
            str = [NSString stringWithFormat:@"via %@ for %@", lname, uname];
        } else {
            str = [NSString stringWithFormat:@"for %@", lname];
        }
    } else if ([uname length] > 0) {
        str = [NSString stringWithFormat:@"via %@", uname];
    } else {
        
    }
    height += [title newFrameForText:str];
    
    NSString *txt = [recom objectForKey:@"text"];
    CGFloat txt_height = 0;
    if ([txt length] > 0) {
        txt_height = [text newFrameForText:txt];
        height += txt_height + 6;
    }
    if (! mock) {
        title.text = str; 
        text.text = txt;
        when.frame = CGRectMake(10, (height - 19), 300, 18);
        when.text = [util timeAgoFromRailsString:[recom objectForKey:@"created_at"]];
        user_nid = [recom objectForKey:@"user_nid"];
    }
    return height + 1;
}

- (CGFloat)heightForThumb:(NSDictionary *)thumb {
    // title + text + when + distance
    NSString *txt = [thumb objectForKey:@"text"];
    return 26 + [text newFrameForText:@""];
}

- (CGFloat)heightForRecommendation:(NSDictionary *)recom {
    return 50;
}

@end

/*
 {    
 "recommendations": [
     {
         "location_nid": "4ec8b9d2eef0a679f80008a1",
         "location_city": "San Francisco",
         "location_name": "King of Thai Noodle",
         "created_at": "2011-11-26T07:23:31Z",
         "title": null,
         "recommendation_nid": "4ed093f3eef0a66455000001",
         "token": "10000000000",
         "text": "I recommended King of Thai Noodle via Nom.",
         "lng": null,
         "image_nid": null,
         "lat": null,
         "user_name": Brian Norton,
         "user_nid": "4eccc0fbeef0a64dcf000001"
     },
     {
         "created_at" = "2011-12-13T21:12:19Z";
         "image_nid" = "<null>";
         lat = "37.7901";
         lng = "-122.404";
         "location_city" = "<null>";
         "location_name" = "Nick's Crispy Tacos";
         "location_nid" = "4eccc0fbeef0a64dcf000001";
         "recommendation_nid" = 4ee7bfb3eef0a61a7e000005;
         text = "I just Nommed @ Nick's Crispy Tacos justnom.it/r/d4qg9hifo0";
         title = "<null>";
         token = d4qg9hifo0;
         "user_nid" = 4eccc0fbeef0a64dcf000001;
    }
 ],
 "thumbs": [
     {
        "location": {
             "address": "2800 Leavenworth St San Francisco, CA 94133-1112",
             "city": "San Francisco",
             "fsq_id": null,
             "location_nid": "4ec8b9d2eef0a679f80008a1",
             "name": "King of Thai Noodle",
             "updated_at": "2011-11-20T08:26:58Z",
             "created_at": "2011-11-20T08:26:58Z",
             "street": "2800 Leavenworth St",
             "cross_street": "Near Leavenworth St and Beach St",
             "gowalla_url": null,
             "state": "California"
        },
        "created_at": "2011-11-20T08:26:58Z",
        "value": 2,
        "name" : "Brian Norton"
        "user_nid": "4eccc0fbeef0a64dcf000001"
     }
 ],
 "message": "OK",
 "status": 1
 }
 */