//
//  LocationsViewController.m
//  nom
//
//  Created by Brian Norton on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"

@implementation LocationsViewController

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
    
    self.title = NSLocalizedString(@"Activity", @"Activity");
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/259-list.png"];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    
    
    return self;
    
}

- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

- (void)distanceChanged:(NMFilterDistance)new_dist {
    
    switch (new_dist) {
        case <#constant#>:
            <#statements#>
            break;
            
        default:
            break;
    }
    
    distance = new_dist;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (filter) {
        case NMLocationsFilterAll:
            break;
        case NMLocationsFilterCost:
            break;
        case NMLocationsFilterDistance:
            break;
        case NMLocationsFilterCategory:
            break;
    }
    
    if (filter == NMLocationsFilterAll) {
        return [locations count];
    } else
    if (section == 0)
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
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

    // take current[indexPath.row] and make a location cell that matches the data here
    NSLog(@"INFO locations controller set %d", indexPath.row);
    if ([current count] > indexPath.row) {
        [cell setLocation:[current objectAtIndex:indexPath.row]];
    }
    NSLog(@"done setting up location cell");
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
