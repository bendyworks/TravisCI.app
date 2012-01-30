//
//  BWCDObjectUpdater.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>

@interface BWCDObjectMananger : NSObject

+ (NSManagedObject *)buildWithID:(NSNumber *)build_id;
+ (void)updateRepositoryFromDictionary:(NSDictionary *)repositoryDictionary;
+ (void)updateJobFromDictionary:(NSDictionary *)jobDictionary;
+ (void)appendToJobLog:(NSDictionary *)logDictionary;
@end
