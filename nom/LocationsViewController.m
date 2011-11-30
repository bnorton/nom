//
//  LocationsViewController.m
//  nom
//
//  Created by Brian Norton on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationsViewController.h"
#import "current.h"
#import "Util.h"
#import "LocationCell.h"

@implementation LocationsViewController

@synthesize current_response;

- (id)init
{
    return [self initFilteredBy:NMLocationsFilterAll];
}

- (id)initFilteredBy:(NMLocationsFilter)_filter {

    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
    
    filter = _filter;
    distances = [NSArray arrayWithObjects:__distances];
    distance_values = [NSArray arrayWithObjects:__distances_vals];
    distance = NMFilterDistanceHalf;
    
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/259-list.png"];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    [self fetchLocations];
    
    filtered_by_cost = [[NSMutableArray alloc] initWithCapacity:20];
    filtered_by_distance = [[NSMutableArray alloc] initWithCapacity:20];
    filtered_by_current_category = [[NSMutableArray alloc] initWithCapacity:20];
    
    return self;
    
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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)updateComplete {
    [self doneLoadingTableViewData];
}

- (void)fetchLocations {
    [self fetchLocationsWithOptions:nil];
}

- (void)fetchLocationsWithOptions:(NSDictionary *)options {

//    NSString *categories_str = [categories componentsJoinedByString:@","];
    
    [NMHTTPClient here:[[distance_values objectAtIndex:distance] floatValue] categories:nil cost:nil 
               success:^(NSDictionary *response) {
                   NSLog(@"INFO: here success callback : %@", response);
                   current_response = response;
                   locations = [response objectForKey:@"results"];
                   filter = NMLocationsFilterCost;
                   [self filter_by_cost:@"$$"];
                   [self updateComplete];
                   [self.tableView reloadData];
               } 
               failure:^(NSDictionary *response) {
                   [self updateComplete];
                   NSLog(@"INFO: here failure callback");
               }];
    
}

- (void)filter_by_cost:(NSString *)cost_str {
    if ([filtered_by_cost count] > 0) {
        [filtered_by_cost removeAllObjects];
    }
    NSString *cost;
    for (NSDictionary *record in locations) {
        if (record && ([(cost = [record objectForKey:@"cost"]) length] > 0)) {
            if ([cost isEqualToString:cost_str]) {
                [filtered_by_cost addObject:record];
            }
        }
    }
    NSLog(@"filter_by_cost %@", filtered_by_cost);
}

- (void)filter_by_category:(NSString *)category_nid {
    if ([filtered_by_current_category count] > 0) {
        [filtered_by_current_category removeAllObjects];
    }
    NSString *primary;    
    for (NSDictionary *record in locations) {
        if (record && ([(primary = [record objectForKey:@"primary"]) length] > 0)) {
            if ([primary isEqualToString:category_nid]) {
                [filtered_by_current_category addObject:record];
            }
        }
    }
    
    NSString *secondary;
    for (NSDictionary *record in locations) {
        if (record && ([(secondary = [record objectForKey:@"secondary"]) length] > 0)) {
            if ([primary isEqualToString:category_nid]) {
                [filtered_by_current_category addObject:record];
            }
        }
    }
    
}

- (void)filter_by_cost {
    
}



- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

- (void)distanceChanged:(NMFilterDistance)new_dist {
    
    switch (new_dist) {
        case NMFilterDistanceQuarter:
            
            break;
        case NMFilterDistanceHalf:
            
            break;
        case NMFilterDistanceOne:
            
            break;
        case NMFilterDistanceTwoHalf:
            
            break;
        case NMFilterDistanceFive:
            
            break;
        default:
            break;
    }
    
    distance = new_dist;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ NSInteger count = 0;
    switch (filter) {
        case NMLocationsFilterAll:
            count = [locations count];
            break;
        case NMLocationsFilterCost:
            count = [filtered_by_cost count];
            break;
        case NMLocationsFilterDistance:
            count = [filtered_by_distance count];
            break;
        case NMLocationsFilterCategory:
            count = [filtered_by_current_category count];
            break;
    }
    NSLog(@"INFO locationsViewController cells count: %d", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
//    NSLog(@"INFO: cellForRowAtIndexPath %d, count : %d", indexPath.row, [locations count]);
    
    LocationCell *cell = (LocationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LocationCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    NSArray *current;
    switch (filter) {
        case NMLocationsFilterAll:
            current = locations;
            break;
        case NMLocationsFilterCost:
            current = filtered_by_cost;
            break;
        case NMLocationsFilterDistance:
            current = filtered_by_distance;
            break;
        case NMLocationsFilterCategory:
            current = filtered_by_current_category;
            break;
        default:
            return nil;
    }

    NSLog(@"INFO locations controller set %d", indexPath.row);
    if ([current count] > indexPath.row) {
        [cell setLocation:[current objectAtIndex:indexPath.row]];
    }
    NSLog(@"done setting up location cell");
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.row == 100) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self fetchLocations];
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	_reloading = NO;
    [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"locations_updated_at_date"]];
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
    return [currentUser getDateForKey:@"locations_updated_at_date"];
	
	
}


@end
