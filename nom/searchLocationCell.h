//
//  searchLocationCell.h
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchLocationCell : UITableViewCell {
    UILabel *name;
    UILabel *cross_street;
    UILabel *rank_distance;
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setLocation:(NSDictionary *)location;

@end
