//
//  FollowCell.m
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 24)];
    [name setBackgroundColor:[UIColor darkGrayColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:20]];
    [name setMinimumFontSize:14];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    
    city = [[UILabel alloc] initWithFrame:CGRectMake(90, 34, 200, 24)];
    [city setBackgroundColor:[UIColor darkGrayColor]];
    [city setFont:[UIFont fontWithName:@"TrebuchetMS" size:17]];
    [city setMinimumFontSize:14];
    [city setLineBreakMode:UILineBreakModeTailTruncation];
    [city setNumberOfLines:1];
    [city setTextAlignment:UITextAlignmentLeft];
    [city setTextColor:[UIColor darkGrayColor]];
    
    follower_count = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 24)];
    [follower_count setBackgroundColor:[UIColor darkGrayColor]];
    [follower_count setFont:[UIFont fontWithName:@"TrebuchetMS" size:15]];
    [follower_count setMinimumFontSize:14];
    [follower_count setLineBreakMode:UILineBreakModeTailTruncation];
    [follower_count setNumberOfLines:1];
    [follower_count setTextAlignment:UITextAlignmentLeft];
    [follower_count setTextColor:[UIColor darkGrayColor]];
    
    profile_border = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [profile_border setImage:[UIImage imageNamed:@"70x70.png"]];

    profile_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [profile_image setImage:[UIImage imageNamed:@"placeholder.png"]];

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
    
    [profile_image setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    if ((str = [person objectForKey:@"screen_name"])) {
        name.text = str;
    }
    if ((str = [person objectForKey:@"name"])) {
        name.text = str;
    }
    if ((str = [person objectForKey:@"city"])) {
        city.text = str;
    }
    if ((str = [person objectForKey:@"follower_count"])) {
        follower_count.text = str;
    }
    if ((str = [person objectForKey:@"image_url"])) {
        NSURL *image_url = [NSURL URLWithString:str];
        [profile_image setImageWithURL:image_url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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