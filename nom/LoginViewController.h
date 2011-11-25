//
//  LoginViewController.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UITableViewController <MBProgressHUDDelegate> {
    UITextField *screen_name;
    UITextField *email;
    UITextField *password;
}

- (id)init;

@end
