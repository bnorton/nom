//
//  NMPublishingController.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NMPublishingController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "currentUser.h"
#import "publishToView.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "Util.h"

@implementation NMPublishingController

@synthesize location_nid;

- (id)init
{
    self = [super init];
    if (!self) { return nil; }
    self.title = NSLocalizedString(@"Recommend", @"Publishing");
    self.tabBarItem.image = [UIImage imageNamed:@"activity.png"];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [background setImage:[UIImage imageNamed:@"background4b.png"]];
    [self.view addSubview:background];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    [textView setBackgroundColor:[UIColor lightGrayColor]];
    [textView setKeyboardType:UIKeyboardTypeDefault];
    [textView setReturnKeyType:UIReturnKeyDone];
    
    publishBar = [[publishToView alloc] init];
    [textView setInputView:publishBar];
    
    willShowCamera = true;
        
    [self.view addSubview:textView];
    
    [publishBar.nom addTarget:self action:@selector(nom:) forControlEvents:UIControlEventTouchDown];
    [publishBar.facebook addTarget:self action:@selector(facebook:) forControlEvents:UIControlEventTouchDown];
    [publishBar.attach_image addTarget:self action:@selector(attachImage) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
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

-(void)attachImage {
    [UIActionSheet photoPickerWithTitle:@"Image Source" showInView:self.view presentVC:self 
                onPhotoPicked:^(UIImage *chosenImage) {
        NSData *imageData = UIImagePNGRepresentation(currentImageAttachement);
        NSString *path = NSTemporaryDirectory();
        NSString *tmpPathToFile = [NSString stringWithFormat:@"%@/%@_attached.png", path, location_nid];
        NSString *presence_key = [NSString stringWithFormat:@"%@_image_present?", location_nid];
                    
        [currentUser setBoolean:FALSE ForKey:presence_key];
        
        if([imageData writeToFile:tmpPathToFile atomically:YES]){
            [currentUser setString:tmpPathToFile ForKey:[NSString stringWithFormat:@"%@_image_path",location_nid]];
            [currentUser setDate:[NSDate date] forKey:[NSString stringWithFormat:@"%@_image_date", location_nid]];
            [currentUser setBoolean:YES ForKey:presence_key];
        }

    } onCancel:^{
        
    }];
}

-(void)nom:(UIButton *)button {
    if (nom_state == NMPublishToNomYES) {
        nom_state = NMPublishToNomNO;
        [publishBar.nom setBackgroundImage:nom forState:UIControlStateHighlighted];
        [publishBar.nom setBackgroundImage:nom_dark forState:UIControlStateNormal];
    } else {
        nom_state = NMPublishToNomYES;
        [publishBar.nom setBackgroundImage:nom_dark forState:UIControlStateHighlighted];
        [publishBar.nom setBackgroundImage:nom forState:UIControlStateNormal];
    }
}

-(void)facebook:(UIButton *)button {
    if (facebook_state == NMPublishToFacebookYES) {
        facebook_state = NMPublishToFacebookNO;
        [publishBar.facebook setBackgroundImage:facebook forState:UIControlStateHighlighted];
        [publishBar.facebook setBackgroundImage:facebook_dark forState:UIControlStateNormal];
    } else {
        facebook_state = NMPublishToFacebookYES;
        [publishBar.facebook setBackgroundImage:facebook_dark forState:UIControlStateHighlighted];
        [publishBar.facebook setBackgroundImage:facebook forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [util viewDidAppear:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Methods for grabbing an image from the camera or the photo reel

- (BOOL) startImagePickerControllerType:(UIImagePickerControllerSourceType)type 
             fromViewController: (UIViewController*) controller
             usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO) || 
        (delegate == nil) || (controller == nil)) {
        return NO;
    }
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = type;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

- (void)presentImagePicker {
    if (willShowCamera) {
        [self startImagePickerControllerType:UIImagePickerControllerSourceTypeCamera 
                          fromViewController: self usingDelegate: self];
    } else {
        [self startImagePickerControllerType:UIImagePickerControllerSourceTypePhotoLibrary
                          fromViewController: self usingDelegate: self];
    }
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
        
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        if (willShowCamera) {
           UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        }
        
        currentImageAttachement = imageToSave;
//        [self saveImage];
    }
    
    /** Handle a movie capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    */
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}

@end