//
//  activityCell.h
//  nom
//
//  Created by Brian Norton on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityCell : UITableViewCell {
    UILabel *title;
    UILabel *text;
    UILabel *when;
    UILabel *distance;
    
    NSString *location_nid;
    NSString *user_nid;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupForThumb:(NSDictionary *)thumb;
- (void)setupForRecommendation:(NSDictionary *)recom;

@property (nonatomic, retain) NSString *location_nid;
@property (nonatomic, retain) NSString *user_nid;

@end
