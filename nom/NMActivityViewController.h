//
//  NMActivityViewController.h
//  nom
//
//  Created by Brian Norton on 11/14/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface NMActivityViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSUInteger currently_visible_rows;
    NSArray *activity_items;

	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)fetchActivities;

@property (nonatomic, readwrite, copy) NSArray *activity_items;

- (id)init;

@end
