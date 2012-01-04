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
#import "NMAppDelegate.h"

@implementation NMInitialConnectViewController

- (id)init
{
    self = [super init];
    if (!self) { return nil; }
    
    self.tabBarItem.image = [UIImage imageNamed:@"icons-gray/291-idcard.png"];
    self.title = @"Connect";
    
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
    [item addTarget:self action:@selector(cancelPressed)];
    self.navigationItem.rightBarButtonItem = item;
    
    location = NMInitialConnectLocationPresented; // default to presented
    
    return self;
}

- (id)initLocatedAt:(NMInitialConnectLocation)loc {
    self = [self init];
    location = loc;
    if (loc == NMInitialConnectLocationTab) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

-(void)cancelPressed {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)facebook {
    __block MBProgressHUD *hud = [util showHudInView:self.view];
    
    [[util fbmodel] registerMeSeccuess:^{
        [((NMAppDelegate *)[[UIApplication sharedApplication] delegate]) userIsNowActive];
        if (location == NMInitialConnectLocationPresented) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
        [hud hide:YES];
    } meFailure:^{
        [((NMAppDelegate *)[[UIApplication sharedApplication] delegate]) userIsNowActive];
        if (location == NMInitialConnectLocationPresented) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
        [hud hide:YES];
    }];
    
    [[util fbmodel] authorizeWithSuccess:^{
        [util shouldShowMessage:@"Facebook connected!" subMessage:nil isError:NO];
    } failure:^{
        [util showErrorInView:self.view message:@"Facebook Connect failed or cancelled :("];
    }];
}

- (void)use_email {
    LoginViewController *login = nil;
    if (location == NMInitialConnectLocationTab) {
        login = [[LoginViewController alloc] initInTabbar];
    } else {
        login = [[LoginViewController alloc] init];
    }
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
