//
//  SettingsViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "currentUser.h"

@implementation SettingsViewController

- (id)initWithType:(NMSettingsSource)_source {
    source = _source;
    return [self init];
}

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return nil; }
    
    labels = [NSArray arrayWithObjects:settings_labels];
    links = [NSArray arrayWithObjects:settings_links];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
