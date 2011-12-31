//
//  ConnectViewController.h
//  nom
//
//  Created by Brian Norton on 11/20/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define me_connect_labels @"Following", @"Followers", @" Recent activity", @" Facebook", @"Settings", @"Find other Nommers", nil
#define other_connect_labels @"Following", @"Followers", @" Recent activity", @"Follow", nil
#define img_frame CGRectMake(10, 5, 40, 40)

#define FB_CONNECTED @" Facebook              Connected"
#define FB_NOT_CONNECTED @" Connect Facebook"
#define fb_image @"icons-gray/208-facebook.png"
#define followers_image @"icons-gray/112-group.png"
#define activity_image @"icons-gray/259-list.png"
#define following_image @"icons-gray/112-group.png"
#define settings_image @"icons-gray/123-id-card.png"
#define search_image @"icons-gray/06-magnify.png"
#define do_follow_image @"icons-gray/55-network.png"

@class MBProgressHUD;

typedef enum {
    NMUserProfileTypeMe,
    NMUserProfileTypeOther
} NMUserProfileType;

@interface ConnectViewController : UITableViewController <MBProgressHUDDelegate> {
    NSArray *labels;
    NSArray *images;
    NMUserProfileType type;
    
    UIImageView *user_image;
    UILabel *user_name;
    UILabel *user_location;
    UILabel *last_seen;
    UILabel *follower_count;
    
    UIView *header;
    
    MBProgressHUD *hud;
    
    BOOL isCurrentUser;
}

@property (nonatomic, copy) NSString *user_nid;

- (id)init;
- (id)initWithType:(NMUserProfileType)type user:(NSDictionary *)user;
- (id)initWithType:(NMUserProfileType)type user_nid:(NSString *)user_nid;

- (void)setupUserContent:(NSDictionary *)user;

@end
