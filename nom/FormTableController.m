//
//  FormTableController.m
//  nom
//
//  Created by Brian Norton on 12/7/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "FormTableController.h"
#import "NMFBModel.h"
#import "Util.h"

@implementation FormTableController

- (id)initWithLocation:(NSDictionary *)location imageUrl:(NSString *)img_url imageNid:(NSString *)img_nid {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (! self) {return nil; }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background4a.png"]];
    [self.tableView setBackgroundView:background];
    
    self.title = @"New Recomemndation";
    
    name = [location objectForKey:@"name"];
	address = [location objectForKey:@"neighborhoods"];
    
    if ([address isKindOfClass:[NSNull class]]) {
        address = nil;
    }
    
	text    = [NSString stringWithFormat:@"I just Nommed @ %@", name];
    image_url = img_url;
    image_nid = img_nid;
    
    textView_ = [[UITextView alloc] initWithFrame:CGRectMake(12, 5, 296, 60)];
    [textView_ setBackgroundColor:[UIColor clearColor]];
    [textView_ setTextColor:[UIColor darkGrayColor]];
    [textView_ setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
	[textView_ setDelegate:self];
    [textView_ setReturnKeyType:UIReturnKeyDefault];
    
    [textView_ setText:text];
    
    return self;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UITextField* tf = nil ;	
	switch ( indexPath.row ) {
		case 0: {
			if (indexPath.section == 0) {
                cell.textLabel.text = @"Name" ;
                tf = nameField_ = [self makeTextField:name];
                [cell addSubview:nameField_];
            } else {
                [cell setBackgroundColor:[UIColor darkGrayColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                [cell.detailTextLabel setText:@"Publish"];
                [cell.textLabel setText:@"Publish"];
            }
			break ;
		}
		case 1: {
			cell.textLabel.text = @"Where" ;
			tf = addressField_ = [self makeTextField:address];
			[cell addSubview:addressField_];
			break ;
		}		
		case 2: {
            if ([textView_ superview]) {
                [textView_ removeFromSuperview];
            }
			[cell addSubview:textView_];
			break ;
		}
	}
    
	tf.frame = CGRectMake(120, 12, 170, 30);
	
	[tf addTarget:self action:@selector(returnKeyPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];	

	tf.delegate = self;
    
    return cell;
}

- (void)submitForm {
    
    __block MBProgressHUD *hud = [util showHudInView:self.view]; [self.view addSubview:hud];
    [hud show:YES];
    
    NSLog(@"submitting");
    text = text == nil ? @"" : text;
    name = name == nil ? @"" : name;
    address = address == nil ? @"" : address;
    image_url = image_url == nil ? @"" : image_url;

    if ([currentUser getBooleanForKey:@"publish_to_facebook"]) {
        [[util fbmodel] publish:text locationName:name city:address imageUrl:image_url success:^{
            [util showInfoInView:self.view message:@"Post(s) were successful"];
            [hud hide:YES];
        } failure:^{
            [util showErrorInView:self.view message:@"Facebook post failed :("];
            [hud hide:YES];
        }];
    }
    if ([currentUser getBooleanForKey:@"publish_to_nom"]) {
        [NMHTTPClient recommend:name imageNid:image_nid text:text facebook:[currentUser getBooleanForKey:@"publish_to_facebook"] 
        success:^(NSDictionary *response) {
            [util showInfoInView:self.view message:@"Post(s) were successful"];
            [hud hide:YES];
        } failure:^(NSDictionary *response) {
            [util showErrorInView:self.view message:@"Nom post failed :("];
            [hud hide:YES];
        }];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    text = textView.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [textView_ resignFirstResponder];
    [self submitForm];
    return YES;
}


- (void)returnKeyPressed:(UITextField *)field {
    switch (current_field) {
        case NMFieldStateZero: {
            [nameField_ resignFirstResponder];
            [addressField_ setReturnKeyType:UIReturnKeyNext];
            [addressField_ becomeFirstResponder];
            current_field = NMFieldStateOne;
            break;
        }
        case NMFieldStateOne: {
            [addressField_ resignFirstResponder];
            [textView_ becomeFirstResponder];
            current_field = NMFieldStateTwo;
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self submitForm];
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 2 ? 70 : 40;
}

#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Memory management


-(UITextField*) makeTextField: (NSString*)_text	{
	UITextField *tf = [[UITextField alloc] init];
	tf.text = _text ;         
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
    tf.font = [UIFont fontWithName:@"TrebuchetMS" size:14];
    [tf setSpellCheckingType:UITextSpellCheckingTypeYes];
	tf.textColor = [UIColor darkGrayColor];
 	// colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f
	return tf;
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ( textField == nameField_ ) {
		name = textField.text ;
	} else if ( textField == addressField_ ) {
		address = textField.text ;
	}
}

- (void)textViewDidEndEditing:(UITextView *)textV {
	
}

@end
