//
//  NMInitialConnectViewController.h
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum {
    NMInitialConnectLocationPresented,
    NMInitialConnectLocationTab
} NMInitialConnectLocation;

@interface NMInitialConnectViewController : UIViewController {
    UIImageView *background;
    UIButton *facebook;
    UIButton *useEmail;
    NMInitialConnectLocation location;
}

- (id)init;
- (id)initLocatedAt:(NMInitialConnectLocation)loc;

@end
