//
//  NMNavigationController.m
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMNavigationController.h"

@implementation NMNavigationController

- (id)initWithRootViewController:(UIViewController *)rvc
{
    self = [super initWithRootViewController:rvc];
    if (! self) { return nil; }
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar4f.png"] 
                            forBarMetrics:UIBarMetricsDefault];

    return self;
}

- (void)setTitleView:(UIView *)titleView {
    [self.navigationItem setTitleView:titleView];
}


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
