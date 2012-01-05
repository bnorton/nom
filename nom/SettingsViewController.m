//
//  SettingsViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "BrowserViewController.h"
#import "current.h"
#import "Util.h"
@implementation SettingsViewController

- (id)initWithType:(NMSettingsSource)_source {
    source = _source;
    return [self init];
}

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return nil; }
    
    self.title = NSLocalizedString(@"Settings", @"Settings");
    
    tabbar_hidden = NO;
    
    labels = [NSArray arrayWithObjects:settings_labels];
    links = [NSArray arrayWithObjects:settings_links];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (tabbar_hidden) {
        [self showTabBar:self.tabBarController];
    }
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark handle toggle

-(void)toggled:(UISwitch *)switc {
    
    NSString *key = nil;
    
    switch (switc.tag) {
        case NOM:
            key = @"publish_to_nom";
            break;
        case FACEBOOK:
            key = @"publish_to_facebook";
            break;
        case TWITTER:
            key = @"publish_to_twitter";
            break;
        
        default: 
        // dont do anything (shouldn't happen)
        return;
    }
    [currentUser setBoolean:switc.isOn ForKey:key];
}


#pragma mark - Make accessory thing

-(void)makeToggleCell:(UITableViewCell *)cell {
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    UISwitch *switc = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [switc addTarget:self action:@selector(toggled:) forControlEvents:UIControlEventValueChanged];
    [cell setAccessoryView:switc];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void)unMakeToggleCell:(UITableViewCell *)cell {
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];    
    [cell setAccessoryView:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}

#pragma mark - Hide tabbar

// thanks to http://stackoverflow.com/questions/5272290/how-to-hide-uitabbarcontroller

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.60];
    for(UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    [UIView commitAnimations];
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.60];
    for(UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        } else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    [UIView commitAnimations]; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    cell.textLabel.text = [labels objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            [self makeToggleCell:cell];
            [((UISwitch *)cell.accessoryView) setOn:[currentUser getBooleanForKey:@"publish_to_nom"] animated:NO];
            cell.accessoryView.tag = NOM;
            break;
        case 1:
            [self makeToggleCell:cell];
            [((UISwitch *)cell.accessoryView) setOn:[currentUser getBooleanForKey:@"publish_to_facebook"] animated:NO];
            cell.accessoryView.tag = FACEBOOK;
            break;
        case 2:
            [self makeToggleCell:cell];
            [((UISwitch *)cell.accessoryView) setOn:[currentUser getBooleanForKey:@"publish_to_twitter"] animated:NO];
            cell.accessoryView.tag = TWITTER;
            break;
        case 3:
        case 4:
        case 5:
        case 6:
            [self unMakeToggleCell:cell];
            break;
        default:
            
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *link = nil;
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            break;
        case 3:
            link = [links objectAtIndex:0];
            break;
        case 4:
            link = [links objectAtIndex:1];
            break;
        case 5:
            link = [links objectAtIndex:2];
            break;
        case 6:
            link = [links objectAtIndex:3];
        default:
            break;
    }
    if (link != nil) {
        tabbar_hidden = YES;
        BrowserViewController *brow = [[BrowserViewController alloc] initWithUrls:[NSURL URLWithString:link]];
        [self hideTabBar:self.tabBarController];
        [self.navigationController pushViewController:brow animated:YES];
    }

}

@end
