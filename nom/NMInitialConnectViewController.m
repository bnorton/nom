//
//  NMInitialConnectViewController.m
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NMInitialConnectViewController.h"
#import "AFHTTPClient.h"

@implementation NMInitialConnectViewController

- (id)init
{
    self = [super init];
    if (!self) { return nil; }
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [background setImage:[UIImage imageNamed:@"initial_background.png"]];
    [self.view addSubview:background];
    
    facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebook setFrame:CGRectMake(20, 200, 160, 50)];
    [facebook setImage:[UIImage imageNamed:@"fb_register1a.png"] forState:UIControlStateNormal];
    [facebook addTarget:self action:@selector(facebook) forControlEvents:UIControlEventTouchUpInside];
    
    useEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [useEmail setFrame:CGRectMake(20, 260, 280, 40)];
    [useEmail.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [useEmail.titleLabel setTextColor:[UIColor blueColor]];
    [useEmail.titleLabel setText:@"Use my email instead"];
    
    [self.view addSubview:facebook];
    [self.view addSubview:useEmail];
    
    return self;
}

-(void)facebook {
    NSLog(@"Facebook in NMInitialConnect");
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
