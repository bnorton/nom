//
//  FollowerListViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "FollowerListViewController.h"
#import "ConnectViewController.h"
#import "FollowCell.h"
#import "Util.h"
#import "current.h"

@implementation FollowerListViewController

@synthesize user_nid;

- (id)initWithType:(NMFollower)_type userNid:(NSString *)_user_nid {
    
    self = [self init];
    type = _type;
    user_nid = _user_nid;
    
    if (type == NMFollowersType) {
        self.title = NSLocalizedString(@"Followers", @"Followers");
        [self updateFollowersShowingHUD:YES];
    } else if (type == NMFollowingType) {
        self.title = NSLocalizedString(@"Following", @"Following");
        [self updateFollowingShowingHUD:YES];
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
    [self.tableView reloadData];
}

- (void)updateFollowersShowingHUD:(BOOL)show {
    MBProgressHUD *hud = nil;
    if (show) {
        hud = [util showHudInView:self.tableView];
    }
    [NMHTTPClient followersFor:user_nid withSuccess:^(NSDictionary *_response) {
        response = _response;
        if ([response objectForKey:@"status"] > 0) {
            follows = [response objectForKey:@"results"];
        }
        [self updateComplete];
        [hud hide:YES];
    } failure:^(NSDictionary *_response) {
        response = _response;
        follows = nil;
        [self updateComplete];
        [hud hide:YES];
        [util showErrorInView:self.view message:@"Couldn't load followers"];
    }];
}

- (void)updateFollowingShowingHUD:(BOOL)show {
    MBProgressHUD *hud = nil;
    if (show) {
        hud = [util showHudInView:self.tableView];
    }
    [NMHTTPClient followingFor:user_nid withSuccess:^(NSDictionary *_response) {
        response = _response;
        if ([response objectForKey:@"status"] > 0) {
            follows = [response objectForKey:@"results"];
        }
        [self updateComplete];
        [hud hide:YES];
    } failure:^(NSDictionary *_response) {
        response = _response;
        follows = nil;
        [self updateComplete];
        [hud hide:YES];
        [util showErrorInView:self.view message:@"Couldn't load following"];
    }];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [follows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    if ([follows count] > indexPath.row) {
        id _person = [follows objectAtIndex:indexPath.row];
        if ([_person isKindOfClass:[NSDictionary class]]) {
            NSDictionary *person = (NSDictionary *)_person;
            [((FollowCell *)cell) setFollower:person];
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        NSDictionary *follower = [follows objectAtIndex:indexPath.row];
        ConnectViewController *user = [[ConnectViewController alloc] 
                                       initWithType:NMUserProfileTypeOther 
                                       user_nid:[follower objectForKey:@"user_nid"]];
        [self.navigationController pushViewController:user animated:YES];
    } @catch (NSException *ex) {
        [util showErrorInView:self.view message:@"Couldn't parse user for detail"];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {	
	_reloading = YES;
    if (type == NMFollowersType) {
        [self updateFollowersShowingHUD:NO];
    } else if (type == NMFollowingType) {
        [self updateFollowingShowingHUD:NO];
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
