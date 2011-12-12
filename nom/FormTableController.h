//
//  FormTableController.h
//  nom
//
//  Created by Brian Norton on 12/7/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NMFieldStateZero,
    NMFieldStateOne,
    NMFieldStateTwo,
    NMFieldStateThree
} NMFieldState;

@interface FormTableController : UITableViewController < UITextFieldDelegate, UITextViewDelegate > {
	NSString* name;
	NSString* address;
	NSString* text;
	NSString* image_url;
    NSString* image_nid;
    
	UITextField* nameField_ ;
	UITextField* addressField_ ;
	UITextView* textView_ ;
    
    NMFieldState current_field;
}

- (id)initWithLocation:(NSDictionary *)location imageUrl:(NSString *)img_url imageNid:(NSString *)_image_nid;

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text;

@end
