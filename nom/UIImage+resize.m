//
//  UIImage+resize.m
//  nom
//
//  Created by Brian Norton on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+resize.h"

@implementation UIImage (resize)

-(UIImage*)scaleAndRotateImageToTargetWidth:(NSInteger)width targetHeight:(NSInteger)height
{    
	CGImageRef imgRef = self.CGImage;
    
	CGFloat original_width = CGImageGetWidth(imgRef);
	CGFloat original_height = CGImageGetHeight(imgRef);
    
    CGFloat ratio = original_width/original_height;
    
	CGRect bounds = CGRectMake(0, 0, original_width, original_height);
//	if (original_width > kMaxResolution || original_height > kMaxResolution) {
//		
//        if (ratio > 1) {
////			bounds.size.width = kMaxResolution;
//			bounds.size.height = bounds.size.width / ratio;
//		}
//		else {
////			bounds.size.height = kMaxResolution;
//			bounds.size.width = bounds.size.height * ratio;
//		}
//	}
//    
	CGFloat scaleRatio = bounds.size.width / original_width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
    
	UIGraphicsBeginImageContext(bounds.size);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
        
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, original_width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return imageCopy;
}

-(NSData*)scaleAndRotateImageToMaxResolutionData:(int)resolution
{
	int kMaxResolution = resolution; // Or whatever
    
	CGImageRef imgRef = self.CGImage;
    
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
    
    
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
    
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = self.imageOrientation;
	switch(orient) {
            
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
            
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0F);
			transform = CGAffineTransformScale(transform, -1.0F, 1.0F);
			break;
            
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, (CGFloat)M_PI);
			break;
            
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0F, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0F, -1.0F);
			break;
            
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0F, 1.0F);
			transform = CGAffineTransformRotate(transform, 3.0F * (CGFloat)M_PI / 2.0F);
			break;
            
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0F, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0F * (CGFloat)M_PI / 2.0F);
			break;
            
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0F, 1.0F);
			transform = CGAffineTransformRotate(transform, (CGFloat)M_PI / 2.0F);
			break;
            
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0F);
			transform = CGAffineTransformRotate(transform, (CGFloat)M_PI / 2.0F);
			break;
            
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
	}
    
	UIGraphicsBeginImageContext(bounds.size);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
    
	CGContextConcatCTM(context, transform);
    
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return imageCopy;
}

@end
