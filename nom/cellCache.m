//
//  cellCache.m
//  nom
//
//  Created by Brian Norton on 12/12/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "cellCache.h"

@implementation cellCache

- (id)init {
    return [self initWithMaxCapacity:DEFAULT_CACHE_SIZE];
}

- (id)initWithMaxCapacity:(NSUInteger)max {
    self = [super init];
    if (! self) { return nil; }
    
    cached_cells_lru = [[NSMutableArray alloc] initWithCapacity:max + 5];
    cached_cells = [[NSMutableDictionary alloc] initWithCapacity:max + 5];
    
    cache_size = max;
    return self;

}

- (UITableViewCell *)addCell:(UITableViewCell *)new_cell forKey:(NSString *)key {
    UITableViewCell *old = nil;
    if ([cached_cells count] > DEFAULT_CACHE_SIZE) {
        old = [cached_cells_lru objectAtIndex:0];
        [cached_cells_lru removeObjectAtIndex:0];
        
        [cached_cells removeObjectForKey:key];
    }
    [cached_cells_lru addObject:new_cell];
    [cached_cells setObject:new_cell forKey:key];
    
    return old;
}

-(UITableViewCell *)cellForKey:(NSString *)key {
    UITableViewCell *acc = [cached_cells objectForKey:key];
    @try {
        [cached_cells_lru removeObject:acc];
        [cached_cells_lru addObject:acc];
    } 
    @catch (NSException *ex) {;}
    
    return acc;
}

- (BOOL)hasKey:(NSString *)key {
    return [cached_cells objectForKey:key] != nil;
}

@end
