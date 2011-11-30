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
    
    NSString *buttonText = @"cancel";
    UIImage *buttonImage = [[UIImage imageNamed:@"assets/bar_button1c.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 54, 30);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    /*[button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected]; */
    button.adjustsImageWhenHighlighted = NO;

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return self;
}

- (void)facebook {
    NSLog(@"Facebook in NMInitialConnect");
    [[util fbmodel] authorizeWithSuccess:^{
        NSLog(@"INFO: initial connect callback success");
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } failure:^{
        
    }];
}

- (void)use_email {
    NSLog(@"use_email in NMInitialConnect");
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
