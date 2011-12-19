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


static CGRect title_frame;
static CGRect text_frame;
static CGRect when_frame;
static CGRect distance_frame;


@implementation activityCell

@synthesize location_nid, user_nid;

+ (void)initialize {
    
    static BOOL initalized = NO;
    
    if (! initalized) {
        initalized = YES;
        
        title_frame = CGRectMake(10, 5, 300, 21);
        text_frame = CGRectMake(10, 27, 300, 18);
        when_frame = CGRectMake(10, 42, 300, 18);
        distance_frame = CGRectMake(10, 61, 300, 18);
    }
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    title = [[UILabel alloc] initWithFrame:title_frame];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [title setLineBreakMode:UILineBreakModeTailTruncation];
    [title setNumberOfLines:0];
    [title setTextAlignment:UITextAlignmentLeft];
    [title setTextColor:[UIColor darkGrayColor]];

    text = [[UILabel alloc] initWithFrame:text_frame];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setFont:[UIFont fontWithName:@"TrebuchetMS" size:13]];
    [text setLineBreakMode:UILineBreakModeTailTruncation];
    [text setNumberOfLines:0];
    [text setTextAlignment:UITextAlignmentLeft];
    [text setTextColor:[UIColor darkGrayColor]];

    when = [[UILabel alloc] initWithFrame:when_frame];
    [when setBackgroundColor:[UIColor clearColor]];
    [when setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [when setAdjustsFontSizeToFitWidth:YES];
    [when setMinimumFontSize:8];
    [when setLineBreakMode:UILineBreakModeTailTruncation];
    [when setNumberOfLines:1];
    [when setTextAlignment:UITextAlignmentLeft];
    [when setTextColor:[UIColor darkGrayColor]];

    distance = [[UILabel alloc] initWithFrame:distance_frame];
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
- (void)reset {
    title.frame = title_frame;
    text.frame = text_frame;
}

- (CGFloat)setupForThumb:(NSDictionary *)thumb isMocked:(BOOL)mock {
    CGFloat height = 19;
    
    NSDictionary *location = [thumb objectForKey:@"location"];
    NSDictionary *user = [thumb objectForKey:@"user"];

    NSString *str = [NSString stringWithFormat:@"%@ is %@", [location objectForKey:@"name"],
                     [util textForThumb:[[thumb objectForKey:@"value"] integerValue]]];
    
    NSString *uname = [user objectForKey:@"name"];
    if (([uname length] <= 0)) {
        uname = [user objectForKey:@"screen_name"];
    }
    if (([uname length] > 0)) {
        str = [NSString stringWithFormat:@"%@ says %@", uname, str];
    }
    
    height += [title newFrameForText:str];
    
    if (! mock) {
        title.text = str;
        text.text = @"";
        when.frame = CGRectMake(10, (height - 15), 300, 18);
        when.text = [util timeAgoFromRailsString:[thumb objectForKey:@"created_at"]];
        user_nid = [thumb objectForKey:@"user_nid"];
    } else {
        [self reset];
    }
    
    return height + 5;
}

- (CGFloat)setupForRecommendation:(NSDictionary *)recom isMocked:(BOOL)mock {
    CGFloat height = 19;
    
    NSDictionary *location = [recom objectForKey:@"location"];
    NSDictionary *user = [recom objectForKey:@"user"];
    NSDictionary *image = [recom objectForKey:@"image"];
    
    NSString *lname = [location objectForKey:@"name"];
    
    NSString *uname = [user objectForKey:@"name"];
    if (([uname length] <= 0)) {
        uname = [user objectForKey:@"screen_name"];
    }
    NSString *str = nil;
    
    if ([lname length] > 0 ) {
        if ([uname length] > 0) {
            str = [NSString stringWithFormat:@"via %@ for %@", uname, lname];
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
        text.frame = CGRectMake(10, (height - 17 - text.frame.size.height), text.frame.size.width, text.frame.size.height);
        when.frame = CGRectMake(10, (height - 15), 300, 18);
        when.text = [util timeAgoFromRailsString:[recom objectForKey:@"created_at"]];
        user_nid = [user objectForKey:@"user_nid"];
    } else {
        [self reset];
    }
    
    return height + 5;
}

@end

/*
 
{
 "message": "OK",
 "status": 1,
 "recommendations": 
 [
     {
        "location": {
             "secondary_category": "4ec14b223c61675c60000002",
             "name": "Kokkari Estiatorio",
             "location_nid": "4ec14b223c61675c60000004",
             "fsq_id": "4570691ff964a5205c3e1fe3",
             "city": "San Francisco",
             "address": "200 Jackson St San Francisco, CA 94111-1806",
             "woeid": "12797162",
             "rank_value": 24,
             "created_at": "2011-11-14T17:08:51Z",
             "cost": "$$$",
             "updated_at": "2011-12-05T05:59:08Z",
             "url": null,
             "timeofday": "lunch | dinner",
             "street": "200 Jackson St",
             "rank": "24/7538",
             "cross_street": "Near Jackson St and Front St",
             "phone": "415-981-0983",
             "neighborhoods": "Embarcadero | Financial District",
             "yid": "2300948200",
             "primary_category": "4ec14b223c61675c60000001",
             "gowalla_url": null,
             "state": "California"
         },
         "title": null,
         "token": "lis63nzuy0",
         "recommendation_nid": "4eee30b4a9097427d0000002",
         "text": "I Nommed. justnom.it/r/lis63nzuy0",
         "lng": null,
         "lat": null,
         "image": {
             "size": "600x320#",
             "url": "http://static.justnom.it/47c48ece8c351b8304c4c0f6ceb0062f8a975c56.medium.png",
             "image_nid": "4ed983ce3c616793e2000004"
         },
         "created_at": "2011-12-18T18:28:04Z",
         "user_nid": "4ec0bdce3c61675335000001"
     }
 ],
 "thumbs": 
 [
     {
         "location": {
             "secondary_category": "4ec954403c61671c7e00002b",
             "name": "15 Romolo",
             "location_nid": "4ec9555e3c61671c7e000581",
             "fsq_id": null,
             "city": "San Francisco",
             "address": "15 Romolo Pl San Francisco, CA 94133-4015",
             "woeid": "12797183",
             "rank_value": 1226,
             "created_at": "2011-11-20T19:30:38Z",
             "cost": "$$",
             "updated_at": "2011-12-05T05:59:24Z",
             "url": null,
             "timeofday": "dessert | latenight",
             "street": "15 Romolo Pl",
             "rank": "1226/7538",
             "cross_street": "Between Broadway and Fresno St",
             "phone": "415-398-1359",
             "neighborhoods": "Telegraph Hill",
             "yid": "-370211716258291839",
             "primary_category": "4ec5ad3f3c6167f601000027",
             "gowalla_url": null,
             "state": "California"
         },
         "created_at": "2011-12-18T09:04:50Z",
         "value": 1,
         "user_nid": "4ec0bdce3c61675335000001"
     }
 ],
}
 
 */