//
//  LoginViewController.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UITableViewController <MBProgressHUDDelegate> {
    UITextField *screen_name;
    UITextField *email;
    UITextField *password;
    
    BOOL setupUserWhenDone;
}

- (id)init;
- (id)initInTabbar;

@end
