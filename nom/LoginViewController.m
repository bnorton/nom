//
//  LoginViewController.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "NMHTTPClient.h"
#import "currentUser.h"
#import "MKInfoPanel.h"

@implementation LoginViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return nil; }

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];

    screen_name = [[UITextField alloc] initWithFrame:CGRectMake(95, 5, 205, 30)];
    [screen_name setAdjustsFontSizeToFitWidth:YES];
    [screen_name setAutocorrectionType:UITextAutocorrectionTypeNo];
    [screen_name setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [screen_name setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [screen_name setEnablesReturnKeyAutomatically:YES];
    [screen_name setFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    [screen_name setKeyboardType:UIKeyboardTypeDefault];
    [screen_name setMinimumFontSize:12];
    [screen_name setReturnKeyType:UIReturnKeyNext];
    [screen_name setSpellCheckingType:UITextSpellCheckingTypeNo];
    [screen_name setTextAlignment:UITextAlignmentLeft];
    [screen_name setTextColor:[UIColor darkGrayColor]];
    [screen_name setUserInteractionEnabled:YES];
    
    [screen_name addTarget:self action:@selector(screen_name_ended) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(95, 5, 205, 30)];
    [email setAdjustsFontSizeToFitWidth:YES];
    [email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [email setEnablesReturnKeyAutomatically:YES];
    [email setFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setMinimumFontSize:12];
    [email setReturnKeyType:UIReturnKeyNext];
    [email setSpellCheckingType:UITextSpellCheckingTypeNo];
    [email setTextAlignment:UITextAlignmentLeft];
    [email setTextColor:[UIColor darkGrayColor]];
    [email setUserInteractionEnabled:YES];
        
    [email addTarget:self action:@selector(email_ended) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(95, 5, 205, 30)];
    [password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [password setAutocorrectionType:UITextAutocorrectionTypeNo];
    [password setAdjustsFontSizeToFitWidth:YES];
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [password setEnablesReturnKeyAutomatically:YES];
    [password setFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    [password setKeyboardType:UIKeyboardTypeDefault];
    [password setMinimumFontSize:12];
    [password setReturnKeyType:UIReturnKeyGo];
    [password setSecureTextEntry:YES];
    [password setSpellCheckingType:UITextSpellCheckingTypeNo];
    [password setTextAlignment:UITextAlignmentLeft];
    [password setTextColor:[UIColor darkGrayColor]];
    [password setUserInteractionEnabled:YES];
    
    [password addTarget:self action:@selector(password_ended) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    return self;
}

- (void)screen_name_ended {
    [screen_name resignFirstResponder];
    [email becomeFirstResponder];
}

- (void)email_ended {
    [email resignFirstResponder];
    [password becomeFirstResponder];
}

-(void)password_ended {
    NSLog(@"should be logging in %@, %@, %@", screen_name.text, email.text, password.text);
    
    MBProgressHUD *hud = [util showHudInView:self.view];
    
    [NMHTTPClient registerUserEmail:email.text password:password.text screen_name:screen_name.text success:^(NSDictionary *response) {
        NSLog(@"INFO registerUserEmail success callback: %@",response);
        if ([[response objectForKey:@"status"] integerValue] > 0) {
            @try {
                NSDictionary *user = [[response objectForKey:@"results"] objectAtIndex:0];
                [currentUser setUser:user];
                [currentUser setDate:[NSDate date] forKey:@"current_user_detail_fetch_time"];
                
            } @catch (NSException *exception) {
                
            }
        } else {
            
        }
        [hud hide:YES];
    } failure:^(NSDictionary *response) {
        NSLog(@"hud hidden with failure on login");
        [hud hide:YES]; 
    }];
    
}

- (void)didReceiveMemoryWarning
{ [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{ [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [screen_name becomeFirstResponder];
}

- (void)viewDidUnload
{ [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:14]];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Name";
            if ([screen_name superview])
                [screen_name removeFromSuperview];
            [cell addSubview:screen_name];            
            break;
        case 1:
            cell.textLabel.text = @"Email";
            if ([email superview])
                [email removeFromSuperview];
            [cell addSubview:email];
            break;
        case 2:
            cell.textLabel.text = @"Password";
            if ([password superview])
                [password removeFromSuperview];
            [cell addSubview:password];            
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0;
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
