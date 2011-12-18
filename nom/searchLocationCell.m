//
//  searchLocationCell.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "searchLocationCell.h"
#import "Util.h"

@implementation searchLocationCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 28)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:26]];
    [name setMinimumFontSize:13];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setContentMode:UIViewContentModeTop];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    
    cross_street = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, 300, 18)];
    [cross_street setBackgroundColor:[UIColor clearColor]];
    [cross_street setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [cross_street setAdjustsFontSizeToFitWidth:YES];
    [cross_street setMinimumFontSize:8];
    [cross_street setLineBreakMode:UILineBreakModeTailTruncation];
    [cross_street setNumberOfLines:1];
    [cross_street setTextAlignment:UITextAlignmentLeft];
    [cross_street setTextColor:[UIColor darkGrayColor]];
    
    rank_distance = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 300, 18)];
    [rank_distance setBackgroundColor:[UIColor clearColor]];
    [rank_distance setFont:[UIFont fontWithName:@"TrebuchetMS" size:16]];
    [rank_distance setMinimumFontSize:11];
    [rank_distance setAdjustsFontSizeToFitWidth:YES];
    [rank_distance setLineBreakMode:UILineBreakModeTailTruncation];
    [rank_distance setNumberOfLines:1];
    [rank_distance setTextAlignment:UITextAlignmentLeft];
    [rank_distance setTextColor:[UIColor darkGrayColor]];
    
    [self addSubview:name];
    [self addSubview:cross_street];
    [self addSubview:rank_distance];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return self;
}

- (void)setLocation:(NSDictionary *)location {
    
    NSLog(@"setting up the cell %@",[location objectForKey:@"name"]);
    
    NSString *str, *tmp;
    if ([(str = [location objectForKey:@"name"]) length] > 0){
        name.text = str;
    } else { name.text = nil; }
    
    if ([(str = [location objectForKey:@"address"]) length] > 0) {
        cross_street.text = str;
    } else if ([(str = [location objectForKey:@"cross_street"]) length] > 0) {
        cross_street.text = str;
    } else if ([(str = [location objectForKey:@"city"]) length] > 0){
        cross_street.text = str;
    } else { cross_street.text = nil; }
    
    CGFloat lat, lng;
    NSDictionary *geolocation = [location objectForKey:@"geolocation"];
    if (((lat = [[geolocation objectForKey:@"lat"] floatValue]) != 0.0f) && 
        ((lng = [[geolocation objectForKey:@"lng"] floatValue]) != 0.0f)) {
        
        if ([(str = [location objectForKey:@"rank"]) length] > 0){
            tmp = [currentLocation howFarFromLat:lat Long:lng];
            rank_distance.text = [NSString stringWithFormat:@"ranked: %@ about %@", str, tmp];
        } else {
            rank_distance.text = [currentLocation howFarFromLat:lat Long:lng];
        }
        
    } else if ([(str = [location objectForKey:@"rank"]) length] > 0){
        rank_distance.text = [NSString stringWithFormat:@"ranked: %@", str];
    } else { rank_distance.text = nil; }
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
