//
//  TrendingLocationsViewController.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "TrendingLocationsViewController.h"
#import "Util.h"
#import "current.h"

@implementation TrendingLocationsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
    
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/249-piechart.png"];
    self.title = NSLocalizedString(@"Trending", @"Places close to here");
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util showInfoInView:self.view message:@"Trending is coming soon..."];
    // [util viewDidAppear:self.view];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
