//
//  SearchViewController.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "searchLocationCell.h"
#import "Util.h"

@implementation SearchViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }

    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/06-magnify.png"];
    self.title = NSLocalizedString(@"Search", @"Search");
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
        NSLog(@"WE HAVE A CLASS %@", [[v class] description]);
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    NSLog(@"search bar changed %@", the_field.text);
}

- (void)searchBarDidBegin:(UITextField *)the_field {
    NSLog(@"search bar begin %@", the_field.text);
}

- (void)cancelButtonPressed:(UIButton *)cancel {
    NSLog(@"search bar canceled %@", cancel);
    [search_field resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"textFieldShouldClear");
    [self cancelButtonPressed:nil];
    locations = nil;
    [self setupCellsCache];
    return YES;
}

- (void)fetchedBasedOn:(NSString *)query where:(NSString *)loc {
    
    NSLog(@"INFO: based on location for query %@", query);
    [NMHTTPClient searchLocation:query location:loc success:^(NSDictionary *response) {
        NSLog(@"INFO: success called back from search query %@", response);
        @try {
            current_response = response;
            locations = [response objectForKey:@"results"];
            
            [self setupCellsCache];
        }
        @catch (NSException *exception) {
            locations = nil;
        }
    } failure:^(NSDictionary *response) {
        NSLog(@"INFO: failure called back from search query %@", response);
        
    }];
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
    NSLog(@"numRowsInSection %d", [locations count]);
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    searchLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[searchLocationCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    if ([locations count] > indexPath.row) {
        [cell setLocation:[locations objectAtIndex:indexPath.row]];
    } else { 
        NSLog(@"There was no location at that index, that is ODD %d", indexPath.row); 
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [util showInfoInView:self.view message:@"didSelectRowAtIndexPath"];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {  
    [util showInfoInView:self.view message:@"filterContentForSearchText"];
}     

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {  
      // Return YES to cause the search result table view to be reloaded.  
    [util showInfoInView:self.view message:@"shouldReloadTableForSearchString"];  
    return YES;  
}  

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {  
    // Return YES to cause the search result table view to be reloaded.  
    [util showInfoInView:self.view message:@"shouldReloadTableForSearchScope"];  
    return YES;  
}  

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {  
    [util showInfoInView:self.view message:@"searchDisplayControllerDidBeginSearch"];
}  

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {  
    [util showInfoInView:self.view message:@"searchDisplayControllerDidEndSearch"];
}

@end
