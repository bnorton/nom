//
//  searchUserCell.h
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchUserCell : UITableViewCell {
    UILabel *name;
    UILabel *where;
    UILabel *counts;
    
    UIImageView *user_image;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)setUser:(NSDictionary *)user isMocked:(BOOL)mocked;

@end
