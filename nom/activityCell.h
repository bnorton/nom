//
//  activityCell.h
//  nom
//
//  Created by Brian Norton on 12/1/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityCell : UITableViewCell {
    UILabel *title;
    UILabel *text;
    UILabel *when;
    UILabel *distance;
    
    NSString *location_nid;
    NSString *user_nid;
    
    UIImageView *image_frame;
    UIImageView *image;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (CGFloat)setupForThumb:(NSDictionary *)thumb isMocked:(BOOL)mock;
- (CGFloat)setupForRecommendation:(NSDictionary *)recom isMocked:(BOOL)mock;

@property (nonatomic, retain) NSString *location_nid;
@property (nonatomic, retain) NSString *user_nid;

@end
