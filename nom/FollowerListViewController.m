//
//  FollowerListViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "FollowerListViewController.h"
#import "UserDetailViewController.h"
#import "Util.h"
#import "current.h"
#import "FollowCell.h"

@implementation FollowerListViewController


- (id)initWithType:(NMFollower)_type {
    
    self = [self init];
    type = _type;
    
    if (type == NMFollowersType) {
        self.title = NSLocalizedString(@"Followers", @"Followers");
        [self updateFollowers];
    } else if (type == NMFollowingType) {
        self.title = NSLocalizedString(@"Following", @"Following");
        [self updateFollowing];
    }
    
    return self;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) { return nil; }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    return self;
}

- (NSString *)type_str {
    if (type == NMFollowersType)
        return @"followers";
    else if (type == NMFollowingType)
        return @"following";

    return @"";
}

- (void)updateComplete {
    [self doneLoadingTableViewData];
}

- (void)updateFollowers {
    NSLog(@"INFO: begin updateFollowers");
    [NMHTTPClient followersWithSuccess:^(NSDictionary *response) {
        NSLog(@"INFO: updateFollowers success %@",response);
        if ([response objectForKey:@"status"] > 0) {
            NSLog(@"INFO followers had status");
            if ([[response objectForKey:@"results"] count] > 0) {
                [currentData setFollowers:[response objectForKey:@"results"]];
                NSLog(@"current followers %@", [currentData followers]);
            }
        }
        [self updateComplete];
        [self.tableView reloadData];
    } failure:^(NSDictionary *response) {
        NSLog(@"INFO: updateFollowers failure");
        [self updateComplete];
    }];
}

- (void)updateFollowing {
    NSLog(@"INFO: begin updateFollowing");
    [NMHTTPClient followingWithSuccess:^(NSDictionary *response) {
        NSLog(@"INFO: updateFollowing success");
        if ([response objectForKey:@"status"] > 0) {
            if ([[response objectForKey:@"results"] count] > 0) {
                [currentData setFollowing:[response objectForKey:@"results"]];
                NSLog(@"current followers %@", [currentData following]);
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];                
            }
        }
        [self updateComplete];
        [self.tableView reloadData];
    } failure:^(NSDictionary *response) {
        NSLog(@"INFO: updateFollowing failure");
        [self updateComplete];
    }];
}

- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *people = nil;
    if (type == NMFollowersType) {
        people = [currentData followers];
    } else if (type == NMFollowingType) {
        people = [currentData following];
    }
    NSInteger ct = [people count];
    NSLog(@"INFO number of Followers %d",ct);
    return ct;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    NSArray *people = nil;
    
    if (type == NMFollowersType) {
        people = [currentData followers];
    } else if (type == NMFollowingType) {
        people = [currentData following];
    }
    
    NSLog(@"FOLLOWERS: for row %d", indexPath.row);
    if ([people count] > indexPath.row) {
        NSLog(@"FOLLOWERS: IN");
        id _person = [people objectAtIndex:indexPath.row];
        if ([_person isKindOfClass:[NSDictionary class]]) {
            NSLog(@"FOLLOWERS: IN2");
            NSDictionary *person = (NSDictionary *)_person;
            [((FollowCell *)cell) setFollower:person];
            NSLog(@"FOLLOWERS: done setting up cell");
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *people = nil;
    
    if (type == NMFollowersType) {
        people = [currentData followers];
    } else if (type == NMFollowingType) {
        people = [currentData following];
    }
    
    if ([people count] > indexPath.row) {
        UserDetailViewController *user = [[UserDetailViewController alloc] initWithUser:[people objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:user animated:YES];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if (type == NMFollowersType) {
        NSLog(@"FOLLOWERS: updating followers");
        [self updateFollowers];
    } else if (type == NMFollowingType) {
        NSLog(@"FOLLOWERS: updating following");
        [self updateFollowing];
    }
	
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	_reloading = NO;
    [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"current_user_date_for_follow_type_%@", [self type_str]]];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    // should return date data source was last changed
    return [currentUser getDateForKey:[NSString stringWithFormat:@"current_user_date_for_follow_type_%@", [self type_str]]];
	
	
}


@end
