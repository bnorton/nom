//
//  NMPublishingController.h
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class publishToView;

typedef enum {
    NMPublishToFacebookYES,
    NMPublishToFacebookNO,
    NMPublishToNomYES,
    NMPublishToNomNO
} NMPublishTo;

@interface NMPublishingController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITextView *textView;
    UIImage *currentImageAttachement;
    UIImage *originalImageAttachment;
    BOOL willShowCamera;
    
    publishToView *publishBar;
    NMPublishTo nom_state;
    NMPublishTo facebook_state;
    
    UIImage *nom;
    UIImage *nom_dark;
    UIImage *facebook;
    UIImage *facebook_dark;
    
    NSString *location_nid;
}

@property (nonatomic, copy) NSString *location_nid;

@end
