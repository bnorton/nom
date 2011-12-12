//
//  cellCache.h
//  nom
//
//  Created by Brian Norton on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_CACHE_SIZE 20

@interface cellCache : NSObject {
    NSUInteger cache_size;
    NSMutableArray *cached_cells_lru;
    NSMutableDictionary *cached_cells;
}


-(id)initWithMaxCapacity:(NSUInteger)max;

- (UITableViewCell *)addCell:(UITableViewCell *)new_cell forKey:(NSString *)key;
- (UITableViewCell *)cellForKey:(NSString *)key;

@end
