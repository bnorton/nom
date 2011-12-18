//
//  FollowCell.h
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface FollowCell : UITableViewCell {
    UILabel *name;
    UILabel *follower_count;
    UILabel *city;
    UIImageView *profile_border;
    UIImageView *profile_image;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setFollower:(NSDictionary *)person;

@property (nonatomic, readwrite, copy) NSString *user_nid;
@property (nonatomic, readwrite, copy) NSString *created_at;

@end

/*
 {
     "city"=>"San Francisco", 
     "created_at"=>Mon, 14 Nov 2011 07:05:50 UTC +00:00, 
     "image_url"=>nil, 
     "follower_count"=>nil, 
     "user_nid"=>"4ec0bdce3c6167533500000b",
     "name" => "real name",
     "facebook" => 14069238423,
     "screen_name"=>"test6"
 }
 */