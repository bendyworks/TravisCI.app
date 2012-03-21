//
//  BWFavoriteHandler.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 3/15/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWFavoriteList : NSObject

@property(nonatomic, retain, readonly) NSMutableOrderedSet *all;

- (void)add:(NSNumber *)remote_id;
- (void)remove:(NSNumber *)remote_id;
- (NSNumber *)objectAtIndex:(NSInteger)index;
- (BOOL)contains:(NSNumber *)remote_id;
- (void)synchronize;

@end
