//
//  NMInitialConnectViewController.m
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMInitialConnectViewController.h"
#import "LoginViewController.h"
#import "NMBarButtonItem.h"
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
    [facebook setFrame:CGRectMake(50, 130, 220, 40)];
    [facebook setImage:[UIImage imageNamed:@"assets/fb_connect1a.png"] forState:UIControlStateNormal];
    [facebook addTarget:self action:@selector(facebook) forControlEvents:UIControlEventTouchUpInside];
    
    useEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [useEmail setFrame:CGRectMake(20, 230, 280, 40)];
    [useEmail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [useEmail setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [useEmail setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [useEmail setTitle:@"or, just Register via Email" forState:UIControlStateNormal];
    [useEmail addTarget:self action:@selector(use_email) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:facebook];
    [self.view addSubview:useEmail];
    
    NMBarButtonItem *item = [[NMBarButtonItem alloc] initWithText:@"Cancel" color:NMBarButtonItemColorRed];
    [item addTarget:self.navigationController action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.rightBarButtonItem = item;
    
    return self;
}

- (void)facebook {
    [[util fbmodel] authorizeWithSuccess:^{
        [self.navigationController dismissModalViewControllerAnimated:YES];
        [util shouldShowMessage:@"Facebook connected!" subMessage:nil isError:NO];
    } failure:^{
        [util showErrorInView:self.view message:@"Facebook Connect failed or cancelled :("];
    }];
}

- (void)use_email {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
