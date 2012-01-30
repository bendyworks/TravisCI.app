//
//  TravisCI.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BWCDBuild;

@interface BWCDRepository : NSManagedObject

@property (nonatomic, retain) NSNumber * last_build_duration;
@property (nonatomic, retain) NSDate * last_build_finished_at;
@property (nonatomic, retain) NSNumber * last_build_id;
@property (nonatomic, retain) NSString * last_build_language;
@property (nonatomic, retain) NSString * last_build_number;
@property (nonatomic, retain) NSNumber * last_build_result;
@property (nonatomic, retain) NSDate * last_build_started_at;
@property (nonatomic, retain) NSNumber * last_build_status;
@property (nonatomic, retain) NSString * remote_description;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSSet *builds;
@end

@interface BWCDRepository (CoreDataGeneratedAccessors)

- (void)addBuildsObject:(BWCDBuild *)value;
- (void)removeBuildsObject:(BWCDBuild *)value;
- (void)addBuilds:(NSSet *)values;
- (void)removeBuilds:(NSSet *)values;

@end
