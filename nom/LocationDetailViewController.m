//
//  LocationDetailViewController.m
//  nom
//
//  Created by Brian Norton on 11/30/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "FormTableController.h"
#import "current.h"
#import "Util.h"
#include <stdlib.h>

@implementation LocationDetailViewController

@synthesize location;

- (id)initWithLocation:(NSDictionary *)_location {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
    
    location = _location;
    location_nid = [location objectForKey:@"location_nid"];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 24)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:22]];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setMinimumFontSize:12];
    [name setContentMode:UIViewContentModeCenter];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];

    address = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    [address setBackgroundColor:[UIColor lightGrayColor]];
    [address setFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    [address setAdjustsFontSizeToFitWidth:YES];
    [address setMinimumFontSize:11];
    [address setContentMode:UIViewContentModeCenter];
    [address setLineBreakMode:UILineBreakModeTailTruncation];
    [address setNumberOfLines:1];
    [address setTextAlignment:UITextAlignmentLeft];
    [address setTextColor:[UIColor darkGrayColor]];

    categories = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, 190, 18)];
    [categories setBackgroundColor:[UIColor lightGrayColor]];
    [categories setFont:[UIFont fontWithName:@"TrebuchetMS" size:16]];
    [categories setAdjustsFontSizeToFitWidth:YES];
    [categories setMinimumFontSize:12];
    [categories setContentMode:UIViewContentModeCenter];
    [categories setLineBreakMode:UILineBreakModeTailTruncation];
    [categories setNumberOfLines:1];
    [categories setTextAlignment:UITextAlignmentLeft];
    [categories setTextColor:[UIColor darkGrayColor]];

    rank = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 190, 27)];
    [rank setBackgroundColor:[UIColor lightGrayColor]];
    [rank setFont:[UIFont fontWithName:@"TrebuchetMS" size:25]];
    [rank setAdjustsFontSizeToFitWidth:YES];
    [rank setMinimumFontSize:12];
    [rank setContentMode:UIViewContentModeCenter];
    [rank setLineBreakMode:UILineBreakModeTailTruncation];
    [rank setNumberOfLines:1];
    [rank setTextAlignment:UITextAlignmentLeft];
    [rank setTextColor:[UIColor darkGrayColor]];

    geolocation = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 190, 27)];
    [geolocation setBackgroundColor:[UIColor lightGrayColor]];
    [geolocation setFont:[UIFont fontWithName:@"TrebuchetMS" size:25]];
    [geolocation setAdjustsFontSizeToFitWidth:YES];
    [geolocation setMinimumFontSize:12];
    [geolocation setContentMode:UIViewContentModeCenter];
    [geolocation setLineBreakMode:UILineBreakModeTailTruncation];
    [geolocation setNumberOfLines:1];
    [geolocation setTextAlignment:UITextAlignmentLeft];
    [geolocation setTextColor:[UIColor darkGrayColor]];

    add_image = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [add_image setFrame:CGRectMake(20, 5, 280, 30)];
    [add_image addTarget:self action:@selector(attachImage) forControlEvents:UIControlEventTouchUpInside];
    [add_image setTitle:@"Upload an Image" forState:UIControlStateNormal];
    [add_image setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [add_image setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [add_image setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    publish = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [publish setFrame:CGRectMake(20, 5, 280, 30)];
    [publish addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [publish setTitle:@"Recommend to followers" forState:UIControlStateNormal];
    [publish setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [publish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [publish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    thumb = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [thumb setFrame:CGRectMake(20, 5, 280, 30)];
    [thumb addTarget:self action:@selector(thumb) forControlEvents:UIControlEventTouchUpInside];
    [thumb setTitle:@"How was it? (solid/meh)" forState:UIControlStateNormal];
    [thumb setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [thumb setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [thumb setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

//    image_frame = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 160)];
//    [image_frame setImage:[UIImage imageNamed:@"assets/image_frame1g.png"]];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 172)];
    [image setImage:[UIImage imageNamed:@"placeholder.png"]];

    [self performSelector:@selector(setup)];
    
    thumb_buttons = [NSArray arrayWithObjects:THUMB_BUTTONS];
    
    return self;
}

- (void)setup {
    name.text = [location objectForKey:@"name"];
    address.text = [location objectForKey:@"address"];
    
    NSDictionary *metadata;
    metadata = [location objectForKey:@"metadata"];
    if (metadata) {
        categories.text = [[util format_array] stringFromArray:[metadata objectForKey:@"categories"]];
    }
    
    rank = [location objectForKey:@"rank"];
    
    NSDictionary *geol = [location objectForKey:@"geolocation"];
    CGFloat lat, lng;
    lat = [[geol objectForKey:@"lat"] floatValue];
    lng = [[geol objectForKey:@"lng"] floatValue];
    if (lat && lng && lat > 0.0f && lng > 0.0f) {
        geolocation.text = [NSString stringWithFormat:@"%@ at %f, %f", [currentLocation howFarFromLat:lat Long:lng], lat, lng];
    } else {
        geolocation.text = [currentLocation howFarFromLat:lat Long:lng];
    }
    
    @try {
        NSString *url = [[[location objectForKey:@"images"] objectAtIndex:0] objectForKey:@"url"];
        [image setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    @catch (NSException *ex) {
        
    }
}
 
- (void)sendImageReadyMessageNamed:(NSString *)inname {    
    __block NSString *_name = inname;
    if (_name) {
        _name = [NSString stringWithFormat:@" for %@", _name];
    }

    [NMHTTPClient imageUpload:location_nid success:^(NSDictionary *response) {
        [util showInfoInView:self.view message:@"Image upload completed."];
    } failure:^(NSDictionary *response) {
        [util showErrorInView:self.view message:[NSString stringWithFormat:@"Image upload failed%@", _name]];
    } progress:^(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        
    }];
}

- (void)thumbValue:(NSString *)value {
    [NMHTTPClient thumbLocation:location_nid value:value success:^(NSDictionary *response) {
        [util showInfoInView:self.view message:@"Saved your perception."];
    } failure:^(NSDictionary *response) {
        [util showErrorInView:self.view message:@"There was an issue saving your perception."];
    }];
}

- (void)thumb {
    NSString *title = [NSString stringWithFormat:@"%@ was...", name.text];
    [UIActionSheet actionSheetWithTitle:title message:nil buttons:thumb_buttons showFromBar:self.tabBarController.tabBar 
      onDismiss:^(int buttonIndex) {
          if (buttonIndex == 0) {
              [self thumbValue:@"1"];
          } else {
              [self thumbValue:@"2"];              
          }
    } onCancel:^{
        
    }];
}

- (void)publish {
    NSString *url = @"", *nid = @"";
    @try {
        NSDictionary *the_image = [[location objectForKey:@"images"] objectAtIndex:0];
        url = [the_image objectForKey:@"url"];
        nid = [the_image objectForKey:@"image_nid"];
    }
    @catch (NSException *ex) {;}
    FormTableController *form = [[FormTableController alloc] initWithLocation:location imageUrl:url imageNid:nid];
    [self.navigationController pushViewController:form animated:YES];
}

- (void) attachImage {
    NSString *title = nil;
    if ([(title = [location objectForKey:@"name"]) length] > 0) {
        title = [NSString stringWithFormat:@"Add image to %@", title];
    } else { title = @"Pick and Image."; }
    
    [UIActionSheet photoPickerWithTitle:title showFromBar:self.tabBarController.tabBar presentVC:self onPhotoPicked:^(UIImage *chosenImage) {
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        
        NSString *path = NSTemporaryDirectory();
        NSString *tmpPathToFile = [NSString stringWithFormat:@"%@%@_attached.png", path, location_nid];
        NSString *presence_key = [NSString stringWithFormat:@"%@_image_present?", location_nid];

            [currentUser setBoolean:NO ForKey:presence_key];
            
            if([imageData writeToFile:tmpPathToFile atomically:YES]){
                @synchronized (self) {
                    [currentUser setString:tmpPathToFile ForKey:[NSString stringWithFormat:@"%@_image_path",location_nid]];
                    [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"%@_image_date", location_nid]];
                    [currentUser setBoolean:YES ForKey:presence_key];
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self sendImageReadyMessageNamed:[location objectForKey:@"name"]];
                    });
                }
            }
    } onCancel:^{
        
    }];
    
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (indexPath.row == 1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        } else {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    
    if (indexPath.row == 0) { // image + add image
        if ([name superview]) {
            [name removeFromSuperview];
        }
        [cell addSubview:name];
    } 
    else if (indexPath.row == 1) { // basic info
        if ([image superview]) { 
            [image removeFromSuperview];
        }
        [cell addSubview:image]; 
        if ([image_frame superview]) { 
            [image_frame removeFromSuperview];
        }
        [cell addSubview:image_frame]; 
    } 
    else if (indexPath.row == 2) { //map and geolocation
        if ([add_image superview]) {
            [add_image removeFromSuperview];
        }
        [cell addSubview:add_image];
    } else if (indexPath.row == 3) {
        if ([thumb superview]) {
            [thumb removeFromSuperview];
        }
        [cell addSubview:thumb];
    }
    else { // what else is there
        if ([publish superview]) {
            [publish removeFromSuperview];
        }
        [cell addSubview:publish];
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 32;
    } else if (indexPath.row == 1) {
        return 173;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

/*
{
    "results": 
    [{
        "address": "101 4th St San Francisco, CA 94103-3003",
        "city": "San Francisco",
        "fsq_id": "4a5824e5f964a5206db71fe3",
        "is_new": false,
        "location_nid": "4ec8b976eef0a679f8000643",
        "name": "Firewood At Metreon",
        "created_at": "2011-11-20T08:25:26Z",
        "rank_value": 2,
        "woeid": "12797154",
        "area_code": "94103-3003",
        "code": null,
        "cost": "$$",
        "country": "United States",
        "location_hash": "ca487300768b988779a82fc74e7b62d72d3584b38860eab99d2720e65f63254a",
        "ranking": { },
        "creator": null,
        "updated_at": "2011-12-05T06:12:42Z",
        "json_encode": null,
        "primary_category": "4ec8b8a7eef0a679f8000001",
        "schemaless": null,
        "street2": null,
        "timeofday": "lunch | dinner",
        "url": null,
        "metadata": {
            "location_nid": "4ec8b976eef0a679f8000643",
            "yelp_rating": 3.5,
            "ret": 0,
            "rec_c": 0,
            "fsq_checkins": 27189,
            "fsq_categories": 
                [{
                   "name": "Multiplex",
                   "id": "4bf58dd8d48988d180941735",
                   "short": "Cineplex"
                 }],
            "fsq_users": 12036,
            "views": 1,
            "meh": 0,
            "up": 0,
            "rank": 0,
            "categories": 
            [
                "italian"
            ],
            "yelp_count": 99,
            "rank_c": 0,
            "fsq_tips": 117
        },
        "gowalla_name": null,
        "id": 1380,
        "rank": "2/7538",
        "revision_nid": null,
        "street": "101 4th St",
        "images": [ ],
        "cross_street": "Near 4th St and Mission St",
        "geolocation": {
            "location_nid": "4ec8b976eef0a679f8000643",
            "lng": -122.404,
            "lat": 37.7845
        },
        "neighborhoods": "Financial District South",
        "phone": "415-369-6199",
        "thumbs": [ ],
        "facebook": null,
        "fsq_name": "AMC Loews Metreon 16",
        "thumb_count": {
            "up": 0,
            "meh": 0
        },
        "gowalla_url": null,
        "metadata_nid": null,
        "secondary_category": "4ec8b8a8eef0a679f800000e",
        "yid": "44270320",
        "state": "California",
        "twitter": null
    }
]
*/