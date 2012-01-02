//
//  searchUserCell.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "searchUserCell.h"
#import "Util.h"

@implementation searchUserCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (! self) { return nil; }

    name = [[UILabel alloc] initWithFrame:CGRectMake(9, 4, 230, 28)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"TrebuchetMS" size:26]];
    [name setMinimumFontSize:16];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setLineBreakMode:UILineBreakModeTailTruncation];
    [name setContentMode:UIViewContentModeTop];
    [name setNumberOfLines:1];
    [name setTextAlignment:UITextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    
    where = [[UILabel alloc] initWithFrame:CGRectMake(9, 33, 230, 34)];
    [where setBackgroundColor:[UIColor clearColor]];
    [where setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [where setAdjustsFontSizeToFitWidth:YES];
    [where setMinimumFontSize:10];
    [where setLineBreakMode:UILineBreakModeWordWrap];
    [where setNumberOfLines:2];
    [where setTextAlignment:UITextAlignmentLeft];
    [where setTextColor:[UIColor darkGrayColor]];
    
    counts = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 230, 18)];
    [counts setBackgroundColor:[UIColor clearColor]];
    [counts setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
    [counts setMinimumFontSize:11];
    [counts setAdjustsFontSizeToFitWidth:YES];
    [counts setLineBreakMode:UILineBreakModeTailTruncation];
    [counts setNumberOfLines:1];
    [counts setTextAlignment:UITextAlignmentLeft];
    [counts setTextColor:[UIColor darkGrayColor]];
    
    user_image = [[UIImageView alloc] initWithFrame:CGRectMake(253, 5, 62, 62)];
    
    [self addSubview:name];
    [self addSubview:where];
//    [self addSubview:counts];
    [self addSubview:user_image];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return self;
}

- (CGFloat)setUser:(NSDictionary *)user isMocked:(BOOL)mocked  {
    NSString *str, *tmp;
    if ([(str = [user objectForKey:@"name"]) length] > 0) {
        if ([(tmp = [user objectForKey:@"screen_name"]) length] > 0) {
            str = [NSString stringWithFormat:@"%@ (%@)", str, tmp];
        }
        
    } else if ([(str = [user objectForKey:@"screen_name"]) length] > 0) {
        
    } else {
        // haz no name?
        str = @"";
    }
    name.text = str;
    str = @"";
    if ([(str = [user objectForKey:@"city"]) length] > 0) {
        if ([(tmp = [user objectForKey:@"updated_at"]) length] > 0) {
            str = [NSString stringWithFormat:@"Last seen: %@ about %@", str, [util timeAgoFromRailsString:tmp]];
        } else {
            str = [NSString stringWithFormat:@"Last seen: %@", str];
        }
    } 
    tmp = @"";
    
    NSNumber *ct = [user objectForKey:@"follower_count"];
    @try {
        if ([ct performSelector:@selector(length)] > 0) {
            tmp = [NSString stringWithFormat:@" and has %@ follower%@",ct,[ct intValue] == 1 ? @"" : @"s"];
        }
    } @catch (NSException *ex) { tmp = @""; }

    where.text = [NSString stringWithFormat:@"%@%@", str, tmp];
    str = @"";

    if ([(str = [user objectForKey:@"image_url"]) length] > 0) {
        [user_image setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [user_image setImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    [user_image setNeedsDisplay];
    str = @"";
    
    return 0;
}

@end
