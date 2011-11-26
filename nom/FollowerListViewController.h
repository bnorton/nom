//
//  FollowerListViewController.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

typedef enum {
    NMFollowersType,
    NMFollowingType
} NMFollower;

@interface FollowerListViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    NMFollower type;
	
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)updateFollowers;
- (void)updateFollowing;


- (id)initWithType:(NMFollower)type;

@end
