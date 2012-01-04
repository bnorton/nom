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
