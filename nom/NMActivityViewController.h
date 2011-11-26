//
//  NMActivityViewController.h
//  nom
//
//  Created by Brian Norton on 11/14/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

typedef enum {
    NMActivityTypeByUser,
    NMActivityTypeByFollowing
}NMActivityType;

@interface NMActivityViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSUInteger currently_visible_rows;
    NSArray *thumbs;
    NSArray *recommends;

    NSMutableArray *activities;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    NMActivityType type;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)fetchActivities;

@property (nonatomic, readwrite, copy) NSArray *activity_items;
@property (nonatomic, copy) NSString *user_nid;
@property (nonatomic, copy) NSString *name;

- (id)initWithType:(NMActivityType)_type userNid:(NSString *)_user_nid name:(NSString *)_name;
- (id)initWithType:(NMActivityType)_type;

@end
