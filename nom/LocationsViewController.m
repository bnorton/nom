//
//  LocationsViewController.m
//  nom
//
//  Created by Brian Norton on 11/26/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationDetailViewController.h"
#import "current.h"
#import "Util.h"
#import "LocationCell.h"

@interface LocationsViewController (PrivateMethods)
-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location;
-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText;
@end

@implementation LocationsViewController

@synthesize current_response;

- (id)init {
    return [self initFilteredBy:NMLocationsFilterAll];
}

- (id)initFilteredBy:(NMLocationsFilter)_filter {

    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
    
    filter = _filter;
    [self fetchLocations];

    distances = [NSArray arrayWithObjects:__distances];
    distance_values = [NSArray arrayWithObjects:__distances_vals];
    distance = NMFilterDistanceHalf;
    
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/73-radar.png"];
    self.title = NSLocalizedString(@"Nearby", @"Places close to here");
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    filtered_by_cost = [[NSMutableArray alloc] initWithCapacity:20];
    filtered_by_distance = [[NSMutableArray alloc] initWithCapacity:20];
    filtered_by_current_category = [[NSMutableArray alloc] initWithCapacity:20];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:
            CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;		
	}
	[_refreshHeaderView refreshLastUpdatedDate];

//    self.navigationItem.rightBarButtonItem = [self woodBarButtonItemWithText:@"Store"];
//    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
//    [rightButton addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.leftBarButtonItem = [self woodBarButtonItemWithText:@"Edit"];
//    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
//    [leftButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    segmentControlTitles = [NSArray arrayWithObjects:@"Rank", @"Cost", @"Tags", nil];
    UIImage* dividerImage = [UIImage imageNamed:@"assets/view-control-divider.png"];
    id iid = [[CustomSegmentedControl alloc] initWithSegmentCount:segmentControlTitles.count segmentsize:CGSizeMake(BUTTON_SEGMENT_WIDTH, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self];
    self.navigationItem.titleView = iid;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateComplete {
    [self doneLoadingTableViewData];
    [self setupLocations];
}

- (void)fetchLocations {
    [self fetchLocationsWithOptions:nil];
}

- (void)fetchLocationsWithOptions:(NSDictionary *)options {
    [NMHTTPClient here:[[distance_values objectAtIndex:distance] floatValue] categories:nil cost:nil 
       success:^(NSDictionary *response) {
           NSLog(@"INFO: here success callback : %@", response);
           @try {
               current_response = response;
               filtered_by_all = [response objectForKey:@"results"];
               filter = NMLocationsFilterAll;
           } @catch (NSException *ex) {
               [util showErrorInView:self.view message:@"Failed to parse items around here"];
           }
           [self updateComplete];
           [self.tableView reloadData];
       } 
       failure:^(NSDictionary *response) {
           [self updateComplete];
           [util showErrorInView:self.view message:@"Failed to load items around here"];
           NSLog(@"INFO: here failure callback");
       }];
}

- (void)filter_by_cost:(NSString *)cost_str {
    if ([filtered_by_cost count] > 0) {
        [filtered_by_cost removeAllObjects];
    }
    NSString *cost;
    for (NSDictionary *record in filtered_by_all) {
        if (record && ([(cost = [record objectForKey:@"cost"]) length] > 0)) {
            if ([cost isEqualToString:cost_str]) {
                [filtered_by_cost addObject:record];
            }
        }
    }
    locations = filtered_by_cost;
    NSLog(@"filter_by_cost %@", filtered_by_cost);
}

- (void)filter_by_category:(NSString *)category_nid {
    if ([filtered_by_current_category count] > 0) {
        [filtered_by_current_category removeAllObjects];
    }
    NSString *primary;    
    for (NSDictionary *record in filtered_by_all) {
        if (record && ([(primary = [record objectForKey:@"primary"]) length] > 0)) {
            if ([primary isEqualToString:category_nid]) {
                [filtered_by_current_category addObject:record];
            }
        }
    }
    
    NSString *secondary;
    for (NSDictionary *record in filtered_by_all) {
        if (record && ([(secondary = [record objectForKey:@"secondary"]) length] > 0)) {
            if ([primary isEqualToString:category_nid]) {
                [filtered_by_current_category addObject:record];
            }
        }
    }
    locations = filtered_by_current_category;
}

- (void)filter_by_distance {
}

- (void)setupLocations {
    switch (filter) {
        case NMLocationsFilterAll:
            locations = filtered_by_all;
            break;
        case NMLocationsFilterCost:
            locations = filtered_by_cost;
            break;
        case NMLocationsFilterDistance:
            locations = filtered_by_distance;
            break;
        case NMLocationsFilterCategory:
            locations = filtered_by_current_category;
            break;
        default:
            locations = nil;
    }
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    LocationCell *cell = (LocationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LocationCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    NSLog(@"INFO locations controller set %d", indexPath.row);
    if ([locations count] > indexPath.row) {
        [cell setLocation:[locations objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([locations count] > indexPath.row) {
        NSDictionary *locat = [locations objectAtIndex:indexPath.row];
        LocationDetailViewController *loc = [[LocationDetailViewController alloc] initWithLocation:locat];
        [self.navigationController pushViewController:loc animated:YES];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	_reloading = YES;
    [self fetchLocations];
}

- (void)doneLoadingTableViewData {
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
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [currentUser getDateForKey:@"locations_updated_at_date"];	
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == segmentControlTitles.count - 1)
        location = CapRight;
    else
        location = CapMiddle;
    
    UIButton* button = [self woodButtonWithText:[segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    
}

-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:buttonText stretch:CapLeftAndRight]];
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    NSUInteger buttonWidth = 0;
    if (location == CapLeftAndRight)
    {
        buttonWidth = BUTTON_WIDTH;
        buttonImage = [[UIImage imageNamed:@"assets/nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
//        buttonImage = [[UIImage imageNamed:@"assets/bar_button1b.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
//        buttonPressedImage = [[UIImage imageNamed:@"assets/nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    }
    else
    {
        buttonWidth = BUTTON_SEGMENT_WIDTH;
        
        buttonImage = [self image:[[UIImage imageNamed:@"assets/nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
//        buttonImage = [self image:[[UIImage imageNamed:@"assets/bar_button1b.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
        buttonPressedImage = [self image:[[UIImage imageNamed:@"assets/nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    }
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor darkGrayColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor lightGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

- (void)storeAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Store"
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil 
                       otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
}

- (void)editAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Edit"
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil 
                       otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
}

@end
