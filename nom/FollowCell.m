//
//  FollowCell.m
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

@synthesize user_nid, created_at;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, 220, 24)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:20]];
    [name setMinimumFontSize:14];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    
    city = [[UILabel alloc] initWithFrame:CGRectMake(90, 34, 220, 18)];
    [city setBackgroundColor:[UIColor clearColor]];
    [city setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [city setMinimumFontSize:12];
    [city setLineBreakMode:UILineBreakModeTailTruncation];
    [city setNumberOfLines:1];
    [city setTextAlignment:UITextAlignmentLeft];
    [city setTextColor:[UIColor darkGrayColor]];
    
    follower_count = [[UILabel alloc] initWithFrame:CGRectMake(90, 58, 220, 16)];
    [follower_count setBackgroundColor:[UIColor clearColor]];
    [follower_count setFont:[UIFont fontWithName:@"TrebuchetMS" size:13]];
    [follower_count setMinimumFontSize:10];
    [follower_count setLineBreakMode:UILineBreakModeTailTruncation];
    [follower_count setNumberOfLines:1];
    [follower_count setTextAlignment:UITextAlignmentLeft];
    [follower_count setTextColor:[UIColor darkGrayColor]];
    
    profile_border = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    [profile_border setImage:[UIImage imageNamed:@"70x70.png"]];

    profile_image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    [profile_image setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [self addSubview:profile_image];
    [self addSubview:profile_border];
    
    [self addSubview:name];
    [self addSubview:city];
    [self addSubview:follower_count];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFollower:(NSDictionary *)person {
    NSString *str = nil;
    NSString *other = nil;
    
    if ([(str = [person objectForKey:@"name"]) length] > 0) {
        name.text = str;
        if ([(other = [person objectForKey:@"screen_name"]) length] > 0) {
            name.text = [NSString stringWithFormat:@"%@ - ( %@ )", str, other];
        } else {
            name.text = str;
        }
    } else if ([(str = [person objectForKey:@"screen_name"]) length] > 0) {
        name.text = str;
    }
    if ([(str = [person objectForKey:@"name"]) length] > 0) {
        name.text = str;
    }
    if ([(str = [person objectForKey:@"city"]) length] > 0) {
        city.text = [NSString stringWithFormat:@" - %@", str];
    }
    if ([(str = [person objectForKey:@"follower_count"]) length] > 0) {
        follower_count.text = [NSString stringWithFormat:@"Followers: %@", str];
    }
    if ([(str = [person objectForKey:@"image_url"]) length] > 0) {
        NSURL *image_url = [NSURL URLWithString:str];
        [profile_image setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    /* setup the identifier of this cell */
    if ([(str = [person objectForKey:@"user_nid"]) length] > 0) {
        user_nid = str;
    }
    if ([(str = [person objectForKey:@"created_at"]) length] > 0) {
        created_at = str;
    }
    
}


@end

/*
{
    "city"=>"San Francisco", 
    "created_at"=>Mon, 14 Nov 2011 07:05:50 UTC +00:00, 
    "image_url"=>nil, 
    "follower_count"=>nil, 
    "user_nid"=>"4ec0bdce3c6167533500000b", 
    "screen_name"=>"test6"
}
*/