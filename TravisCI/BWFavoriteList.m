//
//  BWFavoriteHandler.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 3/15/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWFavoriteList.h"

static NSString *bwFavoriteList = @"Followed Repositories";
#ifndef KV_STORE
#define KV_STORE [NSUbiquitousKeyValueStore defaultStore]
#endif

@interface BWFavoriteList()
@property(nonatomic, retain, readwrite) NSMutableOrderedSet *all;
- (void)keyValueDidChange:(NSNotification *)notification;
- (void)refreshAll;
- (void)save;
@end

@implementation BWFavoriteList

@synthesize all = _all;

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyValueDidChange:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:KV_STORE];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:KV_STORE];
}

- (NSMutableOrderedSet *)all
{
    if ( ! _all) {
        [self refreshAll];
    }
    return _all;
}

- (void)add:(NSNumber *)remote_id
{
    [self.all insertObject:remote_id atIndex:0];
    [self save];
}

- (void)remove:(NSNumber *)remote_id
{
    [self.all removeObject:remote_id];
    [self save];
}

- (NSNumber *)objectAtIndex:(NSInteger)index
{
    return [self.all objectAtIndex:index];
}

- (BOOL)contains:(NSNumber *)remote_id
{
    __block BOOL found = NO;

    [self.all enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([remote_id isEqualToNumber:obj]) {
            found = YES;
            *stop = YES;
        }
    }];

    return found;
}

#pragma mark -
#pragma mark persistence

- (void)keyValueDidChange:(NSNotification *)notification
{
    NSArray *changedKeys = (NSArray *)[[notification userInfo] valueForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    [changedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([bwFavoriteList isEqualToString:obj]) {
            [self refreshAll];
            *stop = YES;
        }
    }];
}

- (void)refreshAll
{
    NSArray *favs = [KV_STORE arrayForKey:bwFavoriteList];
    if (favs) {
        self.all = [NSMutableOrderedSet orderedSetWithArray:favs];
    } else {
        self.all = [NSMutableOrderedSet orderedSetWithCapacity:6];
        [self save];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favoriteListDidChange" object:nil];
}
     
- (void)save
{
    [KV_STORE setArray:[self.all array] forKey:bwFavoriteList];
}

@end
