//
//  LocationCell.h
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell {
    UILabel *name;
    UILabel *cross_street;
    UILabel *distance;
    UILabel *nom_rank;
    UILabel *up;
    UILabel *meh;
    
    UIImageView *badge;
    UIImageView *shadow;
    UIImageView *up_image;
    UIImageView *meh_image;
    
    UIImageView *image_border;
    UIImageView *image;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setLocation:(NSDictionary *)location;
- (void)setImageURL:(NSString *)url;

@end
