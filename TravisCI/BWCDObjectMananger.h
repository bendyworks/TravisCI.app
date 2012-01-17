//
//  BWCDObjectUpdater.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWCDObjectMananger : NSObject

+ (NSManagedObject *)buildWithID:(NSNumber *)build_id;
+ (void)updateRepositoryFromDictionary:(NSDictionary *)repositoryDictionary;
+ (void)updateJobFromDictionary:(NSDictionary *)jobDictionary;
@end
