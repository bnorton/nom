//
//  SearchViewController.h
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

typedef enum {
    NMSearchTargetUser = 1,
    NMSearchTargetLocation
} NMSearchTarget;

@interface SearchViewController : UITableViewController <UISearchBarDelegate, UITextFieldDelegate>{
    id current_response;
    NSMutableArray *items;
    
    UITextField *search_field;
    UIButton *cancel_button;
    
    NMSearchTarget target;
    __block MBProgressHUD *hud;
}

- (id)initWithSearchTarget:(NMSearchTarget)target;
- (void)fetchedBasedOn:(NSString *)query where:(NSString *)loc;

@end
