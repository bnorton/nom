//
//  publishToView.h
//  nom
//
//  Created by Brian Norton on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface publishToView : UIView {
    UIButton *facebook;
    UIButton *nom;
    UIButton *publish;
    UIButton *attach_image;
}

- (id)init;

@property (nonatomic, retain) UIButton *facebook;
@property (nonatomic, retain) UIButton *nom;
@property (nonatomic, retain) UIButton *publish;
@property (nonatomic, retain) UIButton *attach_image;

@end
