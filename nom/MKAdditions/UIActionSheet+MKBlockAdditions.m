//
//  UIActionSheet+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "UIActionSheet+MKBlockAdditions.h"
#import "Util.h"

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;
static PhotoPickedBlock _photoPickedBlock;
static UIViewController *_presentVC;
static UIView *view_for_spinner;
static MBProgressHUD *hud;

@implementation UIActionSheet (MKBlockAdditions)

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
    }
}

+(void) actionSheetWithTitle:(NSString*) title
                     message:(NSString*) message
                     buttons:(NSArray*) buttonTitles
                 showFromBar:(id) bar
                   onDismiss:(DismissBlock) dismissed                   
                    onCancel:(CancelBlock) cancelled
{    
    [UIActionSheet actionSheetWithTitle:title 
                                message:message 
                 destructiveButtonTitle:nil 
                                buttons:buttonTitles 
                            showFromBar:bar
                              onDismiss:dismissed 
                               onCancel:cancelled];
}

+ (void) actionSheetWithTitle:(NSString*) title                     
                      message:(NSString*) message          
       destructiveButtonTitle:(NSString*) destructiveButtonTitle
                      buttons:(NSArray*) buttonTitles
                  showFromBar:(id) bar
                    onDismiss:(DismissBlock) dismissed                   
                     onCancel:(CancelBlock) cancelled
{
    [_cancelBlock release];
    _cancelBlock  = [cancelled copy];
    
    [_dismissBlock release];
    _dismissBlock  = [dismissed copy];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title 
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:destructiveButtonTitle 
                                                    otherButtonTitles:nil];
    
    for(NSString* thisButtonTitle in buttonTitles)
        [actionSheet addButtonWithTitle:thisButtonTitle];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    actionSheet.cancelButtonIndex = [buttonTitles count];
    
    if(destructiveButtonTitle)
        actionSheet.cancelButtonIndex ++;
    
    if([bar isKindOfClass:[UITabBar class]])
        [actionSheet showFromTabBar:(UITabBar*) bar];
    
    if([bar isKindOfClass:[UIToolbar class]])
        [actionSheet showFromBarButtonItem:(UIBarButtonItem*) bar animated:YES];
    
    [actionSheet release];
    
}

+ (void) photoPickerWithTitle:(NSString*) title
                  showFromBar:(id) bar
                    presentVC:(UIViewController*) presentVC
                onPhotoPicked:(PhotoPickedBlock) photoPicked                   
                     onCancel:(CancelBlock) cancelled
{
    view_for_spinner = nil;

    [_cancelBlock release];
    _cancelBlock  = [cancelled copy];
    
    [_photoPickedBlock release];
    _photoPickedBlock  = [photoPicked copy];
    
    [_presentVC release];
    _presentVC = [presentVC retain];
    
    int cancelButtonIndex = -1;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title 
                                                             delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];

	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		[actionSheet addButtonWithTitle:NSLocalizedString(@"Camera", @"")];
		cancelButtonIndex ++;
	}
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		[actionSheet addButtonWithTitle:NSLocalizedString(@"Photo library", @"")];
		cancelButtonIndex ++;
	}
    
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
	cancelButtonIndex ++;
	
    actionSheet.tag = kPhotoActionSheetTag;
	actionSheet.cancelButtonIndex = cancelButtonIndex;		 
        
    if([bar isKindOfClass:[UITabBar class]])
        [actionSheet showFromTabBar:(UITabBar*) bar];
    
    if([bar isKindOfClass:[UIToolbar class]])
        [actionSheet showFromToolbar:(UIToolbar*) bar];
    
    [actionSheet release];    
}


+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *editedImage = (UIImage*) [info valueForKey:UIImagePickerControllerEditedImage];
    if(!editedImage)
        editedImage = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];

    _photoPickedBlock(editedImage);
    
    [hud hide:YES];
    
	[picker dismissModalViewControllerAnimated:YES];	
	[picker autorelease];
}


+ (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    [hud hide:YES];
    [_presentVC dismissModalViewControllerAnimated:YES];    
	[picker autorelease];
    [_presentVC release];
    _cancelBlock();
}

+(void)actionSheet:(UIActionSheet*) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
	if(buttonIndex == [actionSheet cancelButtonIndex])
	{
        [hud hide:YES];
		_cancelBlock();
	}
    else
    {
        if(actionSheet.tag == kPhotoActionSheetTag)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                buttonIndex ++;
            }
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                buttonIndex ++;
            }
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            if(buttonIndex == 1) 
            {                
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else if(buttonIndex == 2)
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;;
            }
            
            [_presentVC presentModalViewController:picker animated:YES];
        }
        else
        {
            _dismissBlock(buttonIndex);
        }
    }
}
@end
