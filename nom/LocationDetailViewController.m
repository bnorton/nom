//
//  LocationDetailViewController.m
//  nom
//
//  Created by Brian Norton on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "current.h"
#import "Util.h"

@implementation LocationDetailViewController

@synthesize location;

- (id)initWithLocation:(NSDictionary *)_location {
    self = [super initWithStyle:UITableViewStylePlain];
    if (! self) { return nil; }
    
    location = _location;
    location_nid = [location objectForKey:@"location_nid"];
    
    return self;
}

- (void)sendImageReadyMessageNamed:(NSString *)name {    
    __block NSString *_name = name;
    if (_name) {
        _name = [NSString stringWithFormat:@" for %@", _name];
    }
    [NMHTTPClient imageUpload:location_nid success:^(NSDictionary *response) {
        NSLog(@"INFO Image uploaded for %@", location_nid);
        [util shouldShowMessage:[NSString stringWithFormat:@"Image uploaded%@", _name] subMessage:nil isError:NO];
    } failure:^(NSDictionary *response) {
        NSLog(@"INFO Image upload failed for %@", location_nid);
        [util shouldShowMessage:[NSString stringWithFormat:@"Image upload failed%@", _name] subMessage:nil isError:YES];
    } progress:^(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@"image upload progress %d, %d", totalBytesWritten, totalBytesExpectedToWrite);
    }];
}

- (void) attachImage {
    NSLog(@"SHOULD BE ATTACHING %@", [location objectForKey:@"location_nid"]);
    NSString *title = nil;
    if ([(title = [location objectForKey:@"name"]) length] <= 0) {
        title = @"Pick and Image.";
    }
    [UIActionSheet photoPickerWithTitle:title showInView:self.view presentVC:self onPhotoPicked:^(UIImage *chosenImage) {
        NSLog(@"IMAGE WAS CHOSEN");
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        
        NSString *path = NSTemporaryDirectory();
        NSString *tmpPathToFile = [NSString stringWithFormat:@"%@%@_attached.png", path, location_nid];
        NSString *presence_key = [NSString stringWithFormat:@"%@_image_present?", location_nid];

        @synchronized (self) {
            [currentUser setBoolean:NO ForKey:presence_key];
            
            if([imageData writeToFile:tmpPathToFile atomically:YES]){
                NSLog(@"INFO: wrote image to path %@", tmpPathToFile);
                [currentUser setString:tmpPathToFile ForKey:[NSString stringWithFormat:@"%@_image_path",location_nid]];
                [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"%@_image_date", location_nid]];
                [currentUser setBoolean:YES ForKey:presence_key];
                NSLog(@"INFO :image is ready for use");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendImageReadyMessageNamed:[location objectForKey:@"name"]];
                });
            }
        }
        NSLog(@"IMAGE PICKING DONE");
    } onCancel:^{
        NSLog(@"INFO: did cancel the photo picker");
    }];
    
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(20, 5, 280, 30)];
    [button addTarget:self action:@selector(attachImage) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
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
