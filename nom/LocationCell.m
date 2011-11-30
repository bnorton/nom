//
//  LocationCell.m
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationCell.h"
#include "Util.h"

@implementation LocationCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }

    name = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 265, 28)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:26]];
    [name setMinimumFontSize:14];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor whiteColor]];
    
    cross_street = [[UILabel alloc] initWithFrame:CGRectMake(10, 187, 300, 18)];
    [cross_street setBackgroundColor:[UIColor lightGrayColor]];
    [cross_street setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [cross_street setAdjustsFontSizeToFitWidth:YES];
    [cross_street setMinimumFontSize:9];
    [cross_street setLineBreakMode:UILineBreakModeTailTruncation];
    [cross_street setNumberOfLines:1];
    [cross_street setTextAlignment:UITextAlignmentLeft];
    [cross_street setTextColor:[UIColor darkGrayColor]];

    distance = [[UILabel alloc] initWithFrame:CGRectMake(10, 207, 300, 18)];
    [distance setBackgroundColor:[UIColor lightGrayColor]];
    [distance setFont:[UIFont fontWithName:@"TrebuchetMS" size:16]];
    [distance setMinimumFontSize:14];
    [distance setLineBreakMode:UILineBreakModeTailTruncation];
    [distance setNumberOfLines:1];
    [distance setTextAlignment:UITextAlignmentLeft];
    [distance setTextColor:[UIColor darkGrayColor]];

    nom_rank = [[UILabel alloc] initWithFrame:CGRectMake(200, 166  , 50, 18)];
    [nom_rank setBackgroundColor:[UIColor lightGrayColor]];
    [nom_rank setFont:[UIFont fontWithName:@"TrebuchetMS" size:16]];
    [nom_rank setMinimumFontSize:14];
    [nom_rank setLineBreakMode:UILineBreakModeTailTruncation];
    [nom_rank setNumberOfLines:1];
    [nom_rank setTextAlignment:UITextAlignmentLeft];
    [nom_rank setTextColor:[UIColor darkGrayColor]];

    up = [[UILabel alloc] initWithFrame:CGRectMake(40, 166, 55, 18)];
    [up setBackgroundColor:[UIColor clearColor]];
    [up setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [up setMinimumFontSize:10];
    [up setLineBreakMode:UILineBreakModeTailTruncation];
    [up setNumberOfLines:1];
    [up setTextAlignment:UITextAlignmentLeft];
    [up setTextColor:[UIColor darkGrayColor]];

    meh = [[UILabel alloc] initWithFrame:CGRectMake(128, 166, 55, 18)];
    [meh setBackgroundColor:[UIColor clearColor]];
    [meh setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [meh setMinimumFontSize:10];
    [meh setLineBreakMode:UILineBreakModeTailTruncation];
    [meh setNumberOfLines:1];
    [meh setTextAlignment:UITextAlignmentLeft];
    [meh setTextColor:[UIColor darkGrayColor]];

    image_border = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 180)];
    [image_border setImage:[UIImage imageNamed:@"assets/image_frame3a.png"]];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 300, 161)];
    [image setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    shadow = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 296, 60)];
    [shadow setImage:[UIImage imageNamed:@"assets/frame_shadow1a.png"]];

    up_image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 164, 18, 22)];
    [up_image setImage:[UIImage imageNamed:@"assets/thumb_up1c.png"]];
    
    meh_image = [[UIImageView alloc] initWithFrame:CGRectMake(102, 165, 23, 19)];
    [meh_image setImage:[UIImage imageNamed:@"assets/thumb_meh1a.png"]];
    
    [self addSubview:image];
    [self addSubview:image_border];
    
    [self addSubview:shadow];
    [self addSubview:up_image];
    [self addSubview:meh_image];
    [self addSubview:up];
    [self addSubview:meh];
    
    [self addSubview:name];
    [self addSubview:cross_street];
    [self addSubview:distance];
    [self addSubview:nom_rank];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    return self;
}

- (void)setLocation:(NSDictionary *)location {

    NSString *str;
    NSString *tmp;
    if ([(str = [location objectForKey:@"name"]) length] > 0){
        name.text = str;
    }
    if ([(str = [location objectForKey:@"rank"]) length] > 0){
        nom_rank.text = str;
    }
    if ([(str = [location objectForKey:@"cross_street"]) length] > 0) {
        if ([(tmp = [location objectForKey:@"neighborhoods"]) length] > 0) {
            cross_street.text = [NSString stringWithFormat:@"%@ in %@", str, tmp];
        } else {
            cross_street.text = str;
        }
    } else if ([(str = [location objectForKey:@"street"]) length] > 0) {
        if ([(tmp = [location objectForKey:@"neighborhoods"]) length] > 0) {
            cross_street.text = [NSString stringWithFormat:@"%@ in %@", str, tmp];
        } else {
            cross_street.text = str;
        }
        cross_street.text = tmp;
    } else if ([(str = [location objectForKey:@"neighborhoods"]) length] > 0) {
        cross_street.text = str;
    } else {
        cross_street = [location objectForKey:@"city"];
    }
    
    NSDictionary *geolocation = [location objectForKey:@"geolocation"];
    CGFloat lat;
    CGFloat lng;
    if (((lat = [[geolocation objectForKey:@"lat"] floatValue]) != 0.0f) && 
       ((lng = [[geolocation objectForKey:@"lng"] floatValue]) != 0.0f)) {
        
        distance.text = [currentLocation howFarFromLat:lat Long:lng];
    }
    
    NSDictionary *thumb_count = [location objectForKey:@"thumb_count"];
    up.text = [NSString stringWithFormat:@"%d",[[thumb_count objectForKey:@"up"] integerValue]];
    meh.text = [NSString stringWithFormat:@"%d",[[thumb_count objectForKey:@"meh"] integerValue]];
//    NSLog(@"INFO: did get thmbs %@",thumb_count);
/*    
    if ([(tmp = [location objectForKey:@""]) length] > 0) {
        blah.text = tmp;
    }
*/
    NSString *url;
    if ([(url = [location objectForKey:@"url"]) length] > 0) {
        [image setImageWithURL:[NSURL URLWithString:url]];
    }
}

- (void)setImageURL:(NSString *)url {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{ [super setSelected:selected animated:animated];
}

@end

/*
a_location = {
    "address": "101 Spear St San Francisco, CA 94105-1558",
    "city": "San Francisco",
    "fsq_id": null,
    "is_new": false,
    "name": "Yank Sing",
    "created_at": "2011-11-20T19:26:17Z",
    "woeid": "12797156",
    "area_code": "94105-1558",
    "code": null,
    "cost": "$$$",
    "country": "United States",
    "location_hash": "316712a878c8dadb02097d22b6f0ac038212017748bb23f0e1cb0dcd62aa4fab",
    "ranking": { 
        "average": 2,
        "total": 4
    },
    "creator": null,
    "updated_at": "2011-11-20T19:26:17Z",
    "json_encode": null,
    "primary": "4ec5ad3f3c6167f601000027",
    "schemaless": null,
    "street2": null,
    "timeofday": "lunch | dinner",
    "url": null,
    "metadata": {
        "location_nid": "4ec954593c61671c7e0000a8",
        "yelp_rating": 3.5,
        "ret": 14,
        "rec_c": 0,
        "rank": 0,
        "meh": 0,
        "up": 0,
        "views": 1,
        "categories": 
        [
            "dim sum",
            "arcades"
        ],
        "yelp_count": 1149,
        "rank_c": 0
    },
    "gowalla_name": null,
    "id": 5648,
    "revision_nid": null,
    "street": "101 Spear St",
    "images": [ ],
    "geolocation": {
        "location_nid": "4ec954593c61671c7e0000a8",
        "lng": -122.39395904541,
        "lat": 37.7924842834473
    },
    "cross_street": "Near Spear St and Mission St",
    "thumbs": [ ],
    "neighborhoods": "South Beach",
    "phone": "415-957-9300",
    "thumb_count": {
        "meh": 0,
        "up": 0
    },
    "facebook": null,
    "fsq_name": null,
    "gowalla_url": null,
    "metadata_nid": null,
    "nid": "4ec954593c61671c7e0000a8",
    "secondary": "4ec954593c61671c7e0000a6",
    "yid": "-1787425622251775235",
    "state": "California",
    "twitter": null
}
*/