//
//  UILabel+frame.m
//  nom
//
//  Created by Brian Norton on 12/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "UILabel+frame.h"

@implementation UILabel (frame)

- (CGFloat)newFrameForText:(NSString *)str {
    
    [self setText:str];
    [self sizeToFit];
    return self.frame.size.height;
    
//    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
//    CGSize expectedLabelSize = [self.text sizeWithFont:self.font 
//                                      constrainedToSize:maximumLabelSize 
//                                          lineBreakMode:self.lineBreakMode]; 
//    CGRect newFrame = self.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    self.frame = newFrame;
    
//    return newFrame.size.height;
}


@end
