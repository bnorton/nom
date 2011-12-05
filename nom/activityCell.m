//
//  activityCell.m
//  nom
//
//  Created by Brian Norton on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "activityCell.h"
#import "Util.h"

@implementation activityCell

@synthesize location_nid, user_nid;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 0)];
    text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    when = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    distance = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    location_nid = @"";
    user_nid = @"";    

    [self addSubview:title];
    [self addSubview:text];
    [self addSubview:when];
    [self addSubview:distance];
    
    return self;
}

- (void)setupCommon:(NSDictionary *)common {
    title.text = [common objectForKey:@"location_name"];
    location_nid = [common objectForKey:@"location_nid"];
    @try {
        CGFloat lat = [[common objectForKey:@"lat"] floatValue];
        CGFloat lng = [[common objectForKey:@"lat"] floatValue];
        NSString *far = [currentLocation howFarFromLat:lat Long:lng];
        NSString *city = [common objectForKey:@"city"];
        distance.text = [NSString stringWithFormat:@"from around %@ away in %@", far, city];
    } @catch (NSException *ex) {
        distance.text = [common objectForKey:@"city"];
    }
    
}

- (void)setupForThumb:(NSDictionary *)thumb {
    NSDictionary *location = [thumb objectForKey:@"location"];
    
    text.text = [NSString stringWithFormat:@".. is a %@ in my book", 
                 [util textForThumb:[[thumb objectForKey:@"value"] integerValue]]];
    when.text = @"some date";

    [self setupCommon:location];
    
    user_nid = [thumb objectForKey:@"user_nid"];
    
}

- (void)setupForRecommendation:(NSDictionary *)recom{

    text.text = [recom objectForKey:@"text"];
    when.text = @"some date";

    [self setupCommon:recom];
    
    user_nid = [recom objectForKey:@"user_nid"];

}

- (CGFloat)heightForThumb:(NSDictionary *)thumb {
    return 50;
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
         "location_nid": "4ec8b8fdeef0a679f80002b3",
         "created_at": "2011-11-26T08:26:37Z",
         "title": null,
         "recommendation_nid": "4ed0a2bdeef0a66634000002",
         "token": "d0n5ky7pwh",
         "text": "I really like 15 Romolo and recommended it via Nom. justnom.it/r/d0n5ky7pwh",
         "lng": null,
         "image_nid": null,
         "lat": null,
         "location_city": "San Francisco",
         "location_name": "15 Romolo",
         "user_name": Brian Norton,
         "user_nid": "4eccc0fbeef0a64dcf000001"
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
        "user_nid": "4eccc0fbeef0a64dcf000001"
     }
 ],
 "message": "OK",
 "status": 1
 }
 */