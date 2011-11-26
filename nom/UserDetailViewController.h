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
}

- (id)initWithUser:(NSDictionary *)user;

@end
