//
//  ConnectViewController.m
//  nom
//
//  Created by Brian Norton on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectViewController.h"
#import "FollowerListViewController.h"
#import "SettingsViewController.h"

@implementation ConnectViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return nil; }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect_background"]];
    background.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:background];
    
    labels = [NSArray arrayWithObjects:connect_labels];
    
    UIImage *followers = [UIImage imageNamed:followers_image];
    UIImage *following = [UIImage imageNamed:following_image];
    UIImage *fb        = [UIImage imageNamed:fb_image];
    UIImage *settings  = [UIImage imageNamed:settings_image];
    
    
    images = [NSArray arrayWithObjects:followers,following,fb,settings,nil];
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{ [super viewDidLoad];
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
{ return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return 4; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
    }
    cell.imageView.image = [images objectAtIndex:indexPath.row];
    cell.textLabel.text = [labels objectAtIndex:indexPath.row];
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    
    switch (indexPath.row) {
        case 0:
            viewController = [[FollowerListViewController alloc] initWithType:NMFollowersType];
            break;
        case 1:
            viewController = [[FollowerListViewController alloc] initWithType:NMFollowingType];
            break;
        case 2:
            
            break;
        case 3:
            viewController = [[SettingsViewController alloc] initWithType:NMSettingsSourceConnect];
            break;
        default:
        // don't do anything here
            return;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
