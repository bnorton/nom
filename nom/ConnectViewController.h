//
//  ConnectViewController.h
//  nom
//
//  Created by Brian Norton on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define connect_labels @"Following", @"Followers", @" Recent activity", @" Facebook", @"Settings", nil

#define img_frame CGRectMake(10, 5, 40, 40)

#define fb_image @"icons-gray/208-facebook.png"
#define followers_image @"icons-gray/112-group.png"
#define activity_image @"icons-gray/259-list.png"
#define following_image @"icons-gray/112-group.png"
#define settings_image @"icons-gray/123-id-card.png"

@interface ConnectViewController : UITableViewController {
    NSArray *labels;
    NSArray *images;
}

- (id)init;

@end
