//
//  LocationDetailViewController.h
//  nom
//
//  Created by Brian Norton on 11/30/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THUMB_BUTTONS @"Solid", @"Meh", nil

@class MapViewController;

@interface LocationDetailViewController : UITableViewController {
    NSDictionary *location;
    NSString *location_nid;
    
    UILabel *name;
    UILabel *address;
    UILabel *categories;
    UILabel *rank;
    UILabel *geolocation;
    
    UIButton *add_image;
    UIButton *publish;
    UIButton *thumb;
    UIButton *phone;
    
    NSArray *thumb_buttons;
    
    UIImageView *image;
    UIImageView *image_frame;

    UIImageView *mapFrame;
    
    MapViewController *mapView;
}

@property (nonatomic,retain) NSDictionary *location;

- (id)initWithLocation:(NSDictionary *)_location;

@end
