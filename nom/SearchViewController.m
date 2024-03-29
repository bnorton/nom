//
//  SearchViewController.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "SearchViewController.h"
#import "searchLocationCell.h"
#import "searchUserCell.h"
#import "ConnectViewController.h"
#import "LocationDetailViewController.h"
#import "Util.h"

@implementation SearchViewController

- (id)initWithSearchTarget:(NMSearchTarget)_target {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }

    target = _target;

    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/06-magnify.png"];
    
    NSString *title = target == NMSearchTargetLocation ? @"Search" : @"User Search";
    self.title = NSLocalizedString(title, @"Search");
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    
    [self.tableView setBackgroundView:background];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];  
    searchBar.delegate = self;  
    searchBar.showsCancelButton = YES;  
    [searchBar sizeToFit];  
    self.tableView.tableHeaderView = searchBar;  
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar 
                                                                                           contentsController:self];  
    [searchDisplayController setSearchResultsDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    
    for (id v in searchBar.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *tf = (UITextField *)v;
            search_field = tf;
            search_field.delegate = self;
            [search_field addTarget:self action:@selector(searchButtonPressed:) 
                   forControlEvents:UIControlEventEditingDidEndOnExit];
            [search_field addTarget:self action:@selector(searchBarChanged:)
                   forControlEvents:UIControlEventEditingChanged];
            [search_field addTarget:self action:@selector(searchBarDidBegin:) 
                   forControlEvents:UIControlEventEditingDidBegin];
        } else if ([v isKindOfClass:[UIButton class]]) {
            cancel_button = (UIButton *)v;
            [cancel_button addTarget:self action:@selector(cancelButtonPressed:) 
                    forControlEvents:UIControlEventTouchUpInside];
        } else if ([v isKindOfClass:[UIImageView class]]) {
            [v setImage:[UIImage imageNamed:@"nav_bar4f.png"]];
        }
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (target == NMSearchTargetUser) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)setupCellsCache {
    // do things here first then
    [self.tableView reloadData];
}

- (void)searchButtonPressed:(UITextField *)the_field {
    [self fetchedBasedOn:the_field.text where:nil];
    [search_field resignFirstResponder];
}

- (void)searchBarChanged:(UITextField *)the_field {
    
}

- (void)searchBarDidBegin:(UITextField *)the_field {
    
}

- (void)cancelButtonPressed:(UIButton *)cancel {
    
    [search_field resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self cancelButtonPressed:nil];
    items = nil;
    [self setupCellsCache];
    return YES;
}

- (void)searchLocation:(NSString *)query where:(NSString *)where {
    [NMHTTPClient searchLocation:query location:where success:^(NSDictionary *response) {
        @try {
            current_response = response;
            items = [response objectForKey:@"results"];
            [self setupCellsCache];
        }
        @catch (NSException *ex) {
            items = nil;
        }
        [hud hide:YES];
    } failure:^(NSDictionary *response) {
        [hud hide:YES];    
    }];

}

-(void)searchUser:(NSString *)query {
    [NMHTTPClient searchUser:query success:^(NSDictionary *response) {
        @try {
            current_response = response;
            items = [response objectForKey:@"results"];
            [self setupCellsCache];
        }
        @catch (NSException *ex) {
            items = nil;
        }
        [hud hide:YES];

    } failure:^(NSDictionary *response) {
        items = nil;
        [hud hide:YES];
    }];
}

- (void)fetchedBasedOn:(NSString *)query where:(NSString *)loc {
    hud = [util showHudInView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    if (target == NMSearchTargetLocation) {
        [self searchLocation:query where:loc];
    } 
    else if (target == NMSearchTargetUser) {
        [self searchUser:query];
    }
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (target == NMSearchTargetLocation) {
        if (cell == nil) {
            cell = [[searchLocationCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
    } else if (target == NMSearchTargetUser) {
        if (cell == nil) {
            cell = [[searchUserCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
    }
    if ([items count] > indexPath.row) {
        if (target == NMSearchTargetLocation)
            [(searchLocationCell *)cell setLocation:[items objectAtIndex:indexPath.row]];
        else if (target == NMSearchTargetUser)
            [(searchUserCell *)cell setUser:[items objectAtIndex:indexPath.row] isMocked:NO];
    } else { 
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([items count] > indexPath.row) {
        UIViewController *detail = nil;
        if (target == NMSearchTargetUser) {
            detail = [[ConnectViewController alloc] initWithType:NMUserProfileTypeOther user:[items objectAtIndex:indexPath.row]];
        } else if (target == NMSearchTargetLocation) {
            detail = [[LocationDetailViewController alloc] initWithLocation:[items objectAtIndex:indexPath.row]];
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {  
}     

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {  
    return YES;  
}  

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {  
    return YES;  
}  

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {  
}  

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {  
}

@end
