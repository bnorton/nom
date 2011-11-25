//
//  FollowerListViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "FollowerListViewController.h"
#import "Util.h"

#import "FollowCell.h"

@implementation FollowerListViewController


- (id)initWithType:(NMFollower)_type {
    
    self = [self init];
    type = _type;
    
    if (type == NMFollowersType) {
        self.title = NSLocalizedString(@"Followers", @"Followers");
    } else if (type == NMFollowingType) {
        self.title = NSLocalizedString(@"Following", @"Following");
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

- (void)updateComplete {
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (void)updateFollowers {
    [NMHTTPClient followersWithSuccess:^(NSDictionary *response) {
        
        [self updateComplete];
    } failure:^(NSDictionary *response) {
        
        [self updateComplete];
    }];
}

- (void)updateFollowing {
    [NMHTTPClient followingWithSuccess:^(NSDictionary *response) {
        
        [self updateComplete];
    } failure:^(NSDictionary *response) {
        
        [self updateComplete];
    }];
}

- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

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
- (void)viewDidUnload
{ [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{ [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{ [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{ [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [people count];
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
    
    // go to detail of the user
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
	NSLog(@"FOLLOWERS: doneLoadingTableViewData");
	//  model should call this when its done loading
	_reloading = NO;
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
	NSLog(@"FOLLOWERS: egoRefreshTableHeaderDidTriggerRefresh");
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
