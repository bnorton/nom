//
//  ConnectViewController.m
//  nom
//
//  Created by Brian Norton on 11/20/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "ConnectViewController.h"
#import "FollowerListViewController.h"
#import "NMActivityViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"
#import "NMHTTPClient.h"
#import "Util.h"

@implementation ConnectViewController

@synthesize user_nid;

- (id)init {
//    NSDate *then = [currentUser getDateForKey:@"current_user_detail_fetch_time"];
//    if (then != nil) {
//        NSLog(@"init in ConnectView_Controller %f %@",[then timeIntervalSince1970], [[then class] description]);
//        NSLog(@"time_ago %@", [then timeIntervalSinceDate:[NSDate date]]);
//        if ([[currentUser getDateForKey:@"current_user_detail_fetch_time"] timeIntervalSince1970]) {
//            return [self initWithType:NMUserProfileTypeMe user_nid:[currentUser getStringForKey:@"user_nid"]];
//        }        
//    }
    NSLog(@"init");
    return [self initWithType:NMUserProfileTypeMe user:[currentUser user]];
}

- (id)initWithType:(NMUserProfileType)_type user_nid:(NSString *)_user_nid {
    user_nid = _user_nid;
    isCurrentUser = [user_nid isEqualToString:[currentUser getStringForKey:@"user_nid"]];
    if (isCurrentUser) {
        return [self initWithType:_type user:[currentUser user]]; // break the chain if I am me
    }
     
    self = [self initWithType:_type user:nil];
        
    NSLog(@"INFO isCurrentUser1 %d", isCurrentUser);

    hud = [util showHudInView:self.view];
    [self.view addSubview:hud];
    
    [NMHTTPClient userDetail:user_nid success:^(NSDictionary *response) {
        [hud hide:YES];
        NSLog(@"INFO user detail callback %@", response);
        @try {
            [self setupUserContent:[[response objectForKey:@"results"] objectAtIndex:0]];
            [currentUser setDate:[NSDate date] forKey:@"current_user_detail_fetch_time"];
        } @catch (NSException *ex) {
            [util showErrorInView:self.view message:@"User detail parse failed"];
        }
    } failure:^(NSDictionary *response) {
        [hud hide:YES];
        [util showErrorInView:self.view message:@"Couldn't fetch user details"];        
    }];
    
    return self;
}

- (id)initWithType:(NMUserProfileType)_type user:(NSDictionary *)user {
    
    NSLog(@"INFO: setting the user in the connect view %@",user);
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return nil; }
    
    type = _type;
    if (user) { user_nid = [user objectForKey:@"user_nid"]; }

    isCurrentUser = [user_nid isEqualToString:[currentUser getStringForKey:@"user_nid"]];
    NSLog(@"INFO isCurrentUser %@ %@ %d", user_nid, [currentUser getStringForKey:@"user_nid"], isCurrentUser);

    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/291-idcard.png"];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];

    UIImage *followers = [UIImage imageNamed:followers_image];
    UIImage *following = [UIImage imageNamed:following_image];
    UIImage *activity  = [UIImage imageNamed:activity_image];
    UIImage *fb        = [UIImage imageNamed:fb_image];
    UIImage *settings  = [UIImage imageNamed:settings_image];
    UIImage *search    = [UIImage imageNamed:search_image];
    UIImage *do_follow = [UIImage imageNamed:do_follow_image];
    
    if (type == NMUserProfileTypeMe || isCurrentUser) {
        labels = [NSArray arrayWithObjects:me_connect_labels];
        images = [NSArray arrayWithObjects:followers,following,activity,fb,settings,search,nil];
    } else if (type == NMUserProfileTypeOther) {
        labels = [NSArray arrayWithObjects:other_connect_labels];
        images = [NSArray arrayWithObjects:followers,following,activity,do_follow,nil];
    } else {
        labels = nil; images = nil;
    }
    
    user_name = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 190, 27)];
    [user_name setBackgroundColor:[UIColor clearColor]];
    [user_name setFont:[UIFont fontWithName:@"TrebuchetMS" size:25]];
    [user_name setAdjustsFontSizeToFitWidth:YES];
    [user_name setMinimumFontSize:12];
    [user_name setContentMode:UIViewContentModeCenter];
    [user_name setLineBreakMode:UILineBreakModeTailTruncation];
    [user_name setNumberOfLines:1];
    [user_name setTextAlignment:UITextAlignmentLeft];
    [user_name setTextColor:[UIColor darkGrayColor]];
    
    user_location = [[UILabel alloc] initWithFrame:CGRectMake(120, 39, 190, 21)];
    [user_location setBackgroundColor:[UIColor clearColor]];
    [user_location setFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    [user_location setAdjustsFontSizeToFitWidth:YES];
    [user_location setMinimumFontSize:11];
    [user_location setLineBreakMode:UILineBreakModeTailTruncation];
    [user_location setNumberOfLines:1];
    [user_location setTextAlignment:UITextAlignmentLeft];
    [user_location setTextColor:[UIColor darkGrayColor]];
    
    last_seen = [[UILabel alloc] initWithFrame:CGRectMake(120, 62, 190, 18)];
    [last_seen setBackgroundColor:[UIColor clearColor]];
    [last_seen setFont:[UIFont fontWithName:@"TrebuchetMS" size:16]];
    [last_seen setAdjustsFontSizeToFitWidth:YES];
    [last_seen setMinimumFontSize:11];
    [last_seen setLineBreakMode:UILineBreakModeTailTruncation];
    [last_seen setNumberOfLines:1];
    [last_seen setTextAlignment:UITextAlignmentLeft];
    [last_seen setTextColor:[UIColor darkGrayColor]];
    
    user_image = [[UIImageView alloc] init];
    [user_image setFrame:CGRectMake(10, 10, 100, 100)];
    
    if (type == NMUserProfileTypeMe) {
        // do stuff for uploading image and setup metadata for this being ME
    }
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    
    [header addSubview:user_image];
    [header addSubview:user_location];
    [header addSubview:user_name];
    [header addSubview:last_seen];
    [header addSubview:follower_count];
    
    if (user != nil) { [self setupUserContent:user]; }
    
    return self;
}

- (void)setupUserContent:(NSDictionary *)user {
    
    user_nid = [user objectForKey:@"user_nid"];
    
    NSString *name = @"User", *str, *tmp;
    if ([(str = [user objectForKey:@"name"]) length] > 0) {
        name = str;
    }
    if (type == NMUserProfileTypeOther && isCurrentUser) {
        name = @"You";
    }
    self.title = NSLocalizedString(name, @"User Profile page");
    
    if ([(str = [user objectForKey:@"name"]) length] > 0) {
        user_name.text = str;
    } else if ([(str = [user objectForKey:@"screen_name"]) length] > 0) {
        user_name.text = str;
    }
    user_location.text = [user objectForKey:@"city"];
    
    if ([(str = [user objectForKey:@"updated_at"]) length] > 0) {
        NSLog(@"CONNECT INFO: last seen %@", str);
        if ([(tmp = [util timeAgoFromRailsString:str]) length] > 0) {        
            str = [NSString stringWithFormat:@"last seen: %@", tmp];
        }
        last_seen.text = str;
    }
    
    follower_count.text = [NSString stringWithFormat:@"Followers %@", [user objectForKey:@"follower_count"]];
    
    str = [user objectForKey:@"image_url"];
    NSLog(@"INFO user detail image %@", str);
    [user_image setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void)viewWillAppear:(BOOL)animated { 
    [super viewWillAppear:animated];
    if (type == NMUserProfileTypeMe) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (isCurrentUser) {
        NSString *title = [user_name.text length] > 0 ? user_name.text : @"User";
        self.title = NSLocalizedString(title, @"User Name");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (isCurrentUser) {
        self.title = NSLocalizedString(@"You", @"User Name");
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{ return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)fb_auth:(UITableViewCell *)cell {
    [[util fbmodel] authorizeWithSuccess:^{
        cell.textLabel.text = FB_CONNECTED;
        [util viewDidAppear:self.view];
    } failure:^{
        cell.textLabel.text = FB_NOT_CONNECTED;
        [util showErrorInView:self.view message:@"Facebook connect cancelled or failed"];
    }];
}

-(void)follow_unfollow {
    [NMHTTPClient follow:user_nid success:^(NSDictionary *response) {
        [util showInfoInView:self.view message:[NSString stringWithFormat:@"Now Following %@", user_name.text]];
    } failure:^(NSDictionary *response) {
        [util showErrorInView:self.view message:@"Cound not Follow"];
    }];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return [labels count]; 
}

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
    
    if (indexPath.row == 3 && (type == NMUserProfileTypeMe || isCurrentUser)) {
        if ([[util facebook] isSessionValid]) {
            cell.textLabel.text = FB_CONNECTED;
        } else {
            cell.textLabel.text = FB_NOT_CONNECTED;
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    __block UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            viewController = [[FollowerListViewController alloc] initWithType:NMFollowingType userNid:user_nid];
            break;
        case 1:
            viewController = [[FollowerListViewController alloc] initWithType:NMFollowersType userNid:user_nid];
            break;
        case 2:
            viewController = [[NMActivityViewController alloc] initWithType:NMActivityTypeByUser userNid:user_nid name:user_name.text];
            break;
        case 3:
            cell = [tableView cellForRowAtIndexPath:indexPath];
            if (type == NMUserProfileTypeMe) {
                [self fb_auth:cell];
                [cell setSelected:NO animated:YES];
            } else if (type == NMUserProfileTypeOther){
                [self follow_unfollow];
                [cell setSelected:NO animated:YES];
            }
            return;
            break;
        case 4:
            viewController = [[SettingsViewController alloc] initWithType:NMSettingsSourceConnect];
            break;
        case 5:
            viewController = [[SearchViewController alloc] initWithSearchTarget:NMSearchTargetUser];
            break;
        default:
        // don't do anything here
            return;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

@end
