//
//  NMNavigationController.h
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMNavigationController : UINavigationController

- (id)initWithRootViewController:(UIViewController *)rvc;
- (void)setTitleView:(UIView *)titleView;

@end
