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

@interface FollowerListViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    NMFollower type;
	
    EGORefreshTableHeaderView *_refreshHeaderView;
	
    NSString *user_nid;
    id response;
    NSArray *follows;
    
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

@property (nonatomic, copy) NSString *user_nid;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)updateFollowersShowingHUD:(BOOL)show;
- (void)updateFollowingShowingHUD:(BOOL)show;


- (id)initWithType:(NMFollower)_type userNid:(NSString *)user_nid;

@end
