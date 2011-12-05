//
//  UserDetailViewController.h
//  nom
//
//  Created by Brian Norton on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UITableViewController {
    NSArray *items;
    UIImageView *user_image;
    
    UILabel *user_name;
    UILabel *last_seen;
    UILabel *first;
    
}

- (id)initWithUser:(NSDictionary *)user;

@end
