//
//  NMInitialConnectViewController.m
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NMInitialConnectViewController.h"
#import "LoginViewController.h"
#import "NMHTTPClient.h"

@implementation NMInitialConnectViewController

- (id)init
{
    self = [super init];
    if (!self) { return nil; }
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [background setImage:[UIImage imageNamed:@"background4b.png"]];
    [self.view addSubview:background];
    
    facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebook setFrame:CGRectMake(0, 170, 320, 100)];
    [facebook setImage:[UIImage imageNamed:@"fb_register1b.png"] forState:UIControlStateNormal];
    [facebook addTarget:self action:@selector(facebook) forControlEvents:UIControlEventTouchUpInside];
    
    useEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [useEmail setFrame:CGRectMake(20, 270, 280, 40)];
    [useEmail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [useEmail setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [useEmail setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [useEmail setTitle:@"Use my email address instead" forState:UIControlStateNormal];
    [useEmail addTarget:self action:@selector(use_email) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:facebook];
    [self.view addSubview:useEmail];
    
    return self;
}

- (void)facebook {
    NSLog(@"Facebook in NMInitialConnect");
}

- (void)use_email {
    NSLog(@"use_email in NMInitialConnect");
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
