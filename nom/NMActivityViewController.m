//
//  NMActivityViewController.m
//  nom
//
//  Created by Brian Norton on 11/14/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMActivityViewController.h"
#import "activityCell.h"
#import "NMHTTPClient.h"
#import "current.h"

@implementation NMActivityViewController

@synthesize activity_items, user_nid, name;

- (id)initWithType:(NMActivityType)_type userNid:(NSString *)_user_nid name:(NSString *)_name {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
//    [self.view addSubview:self.navigationController.view];
    
    self.title = NSLocalizedString(@"Timeline", @"All things Nom");
    type = _type;
    
    user_nid = _user_nid;
    name = _name;
        
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/259-list.png"];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    currently_visible_rows = 0;
    thumbs     = nil;
    recommends = nil;
    activities = [[NSMutableArray alloc] initWithCapacity:20];

    [self fetchActivities];
    
    return self;
}

- (id)initWithType:(NMActivityType)_type {
    
    NSString *aname = nil;
    if ([(aname = [currentUser getStringForKey:@"name"]) length] > 0) {}
    else if ([(aname = [currentUser getStringForKey:@"screen_name"]) length] > 0) {} 
    else { aname = @"Activity"; }

    return [self initWithType:_type userNid:[currentUser getStringForKey:@"user_nid"] name:aname];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([user_nid isEqualToString:[currentUser getObjectForKey:@"user_nid"]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)process_activity_list {
    [activities removeAllObjects];
    [activities addObjectsFromArray:thumbs];
    [activities addObjectsFromArray:recommends];
    
//    for (id item in thumbs) { [activities addObject:item]; }
//    for (id item in recommends) { [activities addObject:item]; } 
    
    NSLog(@"INFO process_activity_list %@ ",activities);
    
    [activities sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *one = nil, *two = nil;
        NSString *str1 = nil, *str2 = nil;
        if ([obj1 isKindOfClass:[NSDictionary class]] && 
            [obj1 respondsToSelector:@selector(objectForKey:)]) {
            str1 = [obj1 objectForKey:@"timestamp"];
        }
        if ([obj2 isKindOfClass:[NSDictionary class]] && 
            [obj2 respondsToSelector:@selector(objectForKey:)]) {
            str2 = [obj2 objectForKey:@"timestamp"];
        }
        @try {
            one = [util dateFromRailsString:str1]; 
            two = [util dateFromRailsString:str1]; 
        }
        @catch (NSException *exception) {;}
        
        if (one != nil && two != nil) { 
            return [two compare:one]; 
        }
        return 1;
    }];
    
}

- (void)fetchActivities {
    if (type == NMActivityTypeByFollowing) {
        [NMHTTPClient activitiesWithSuccess:^(NSDictionary *response) {
            current_response = response;
            NSLog(@"INFO Activity following response %@", response);
            if (([response objectForKey:@"status"]) > 0) {
                NSArray *_recommends;
                NSArray *_thumbs;
                if ((_recommends = [response objectForKey:@"recommends"])) {
                    recommends = _recommends;
                    NSLog(@"INFO Activity have recommendations");
                }
                if ((_thumbs = [response objectForKey:@"thumbs"])) {
                    NSLog(@"INFO Activity have thumbs");
                    thumbs = _thumbs;
                }
                [self doneLoadingTableViewData:YES];
            } else {
                [util showErrorInView:self.view message:@"Oh. Activity parsing failed"];
                [self doneLoadingTableViewData:NO];
            }
        } failure:^(NSDictionary *response) {
            [util showErrorInView:self.view message:@"Sorry, Activity fetch failed"];
            [self doneLoadingTableViewData:NO];
        }];
        
    } else if (type == NMActivityTypeByUser) {
        
        [NMHTTPClient usersActivities:user_nid withSuccess:^(NSDictionary *response) {
            current_response = response;
            NSLog(@"INFO Activity users response %@", response);
            NSLog(@"activity fetch success by_user");
            if (([response objectForKey:@"status"]) > 0) {
                NSArray *_recommends;
                NSArray *_thumbs;
                if ((_recommends = [response objectForKey:@"recommendations"])) {
                    recommends = _recommends;
                }
                if ((_thumbs = [response objectForKey:@"thumbs"])) {
                    thumbs = _thumbs;
                }
                [self doneLoadingTableViewData:YES];
            }
            else {
                [self doneLoadingTableViewData:NO];
                [util showErrorInView:self.view message:@"Activity parsing failed"];
            }
            
        } failure:^(NSDictionary *response) {
            [util showErrorInView:self.view message:@"Activity fetch failed"];
            [self doneLoadingTableViewData:NO];
        }];
        
    }
}
							
- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] 
                                           initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 
                                                                    self.view.frame.size.width, 
                                                                    self.tableView.bounds.size.height)];
        view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"INFO Activities rows %d", [activities count]);
    return [activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    activityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[activityCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    @try {
        if (([activities count] > indexPath.row)) {
             if (([[[activities objectAtIndex:indexPath.row] objectForKey:@"recommendation_nid"] length] > 0)) {
                 [cell setupForRecommendation:[activities objectAtIndex:indexPath.row]];
             }
             else {
                 [cell setupForThumb:[activities objectAtIndex:indexPath.row]];
             }
        }
    } @catch (NSException *ex) {
        NSLog(@"had some trouble setting up the cell for %d  EXCEPTION %@",indexPath.row, [ex description]);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	_reloading = YES;    
    [self fetchActivities];
	
}

- (void)doneLoadingTableViewData:(BOOL)success {
    if (success) {
        [self process_activity_list];
    }
    [self.tableView reloadData];
	_reloading = NO;
    NSLog(@"SET activity fetched date %@",user_nid);
    [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"activites_date_for_user_%@", user_nid]];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)doneLoadingTableViewData {
    [self doneLoadingTableViewData:YES];
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
    NSLog(@"get activity date for %@",user_nid);
    return [currentUser getDateForKey:[NSString stringWithFormat:@"activites_date_for_user_%@", user_nid]];
}

@end

/*
{    
"recommendations": [
  {
        "location_nid": "4ec8b9d2eef0a679f80008a1",
        "created_at": "2011-11-26T07:23:31Z",
        "title": null,
        "recommendation_nid": "4ed093f3eef0a66455000001",
        "token": "10000000000",
        "text": "I recommended King of Thai Noodle via Nom.",
        "lng": null,
        "image_nid": null,
        "lat": null,
        "location_city": "San Francisco",
        "location_name": "King of Thai Noodle",
        "user_name": Brian Norton,
        "user_nid": "4eccc0fbeef0a64dcf000001"
  },
  {
        "location_nid": "4ec8b8fdeef0a679f80002b3",
        "created_at": "2011-11-26T08:26:37Z",
        "title": null,
        "recommendation_nid": "4ed0a2bdeef0a66634000002",
        "token": "d0n5ky7pwh",
        "text": "I really like 15 Romolo and recommended it via Nom. justnom.it/r/d0n5ky7pwh",
        "lng": null,
        "image_nid": null,
        "lat": null,
        "location_city": "San Francisco",
        "location_name": "15 Romolo",
        "user_name": Brian Norton,
        "user_nid": "4eccc0fbeef0a64dcf000001"
  }
],
"thumbs": [
   {
       "location": {
           "address": "2800 Leavenworth St San Francisco, CA 94133-1112",
           "city": "San Francisco",
           "fsq_id": null,
           "location_nid": "4ec8b9d2eef0a679f80008a1",
           "name": "King of Thai Noodle",
           "updated_at": "2011-11-20T08:26:58Z",
           "created_at": "2011-11-20T08:26:58Z",
           "street": "2800 Leavenworth St",
           "cross_street": "Near Leavenworth St and Beach St",
           "gowalla_url": null,
           "state": "California"
       },
       "created_at": "2011-11-20T08:26:58Z",
       "value": 2,
       "user_nid": "4eccc0fbeef0a64dcf000001"
   }
           ],
"message": "OK",
"status": 1
}
 */
