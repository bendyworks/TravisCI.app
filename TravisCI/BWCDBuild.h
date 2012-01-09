//
//  BWCDBuild.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BWCDRepository, BWCDJob;

@interface BWCDBuild : NSManagedObject

@property (nonatomic, retain) NSString * author_email;
@property (nonatomic, retain) NSString * author_name;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSString * commit;
@property (nonatomic, retain) NSDate * committed_at;
@property (nonatomic, retain) NSString * committer_email;
@property (nonatomic, retain) NSString * committer_name;
@property (nonatomic, retain) NSString * compare_url;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * finished_at;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSDate * started_at;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * repository_id;
@property (nonatomic, retain) NSSet *jobs;
@property (nonatomic, retain) BWCDRepository *repository;
@end

@interface BWCDBuild (CoreDataGeneratedAccessors)

- (void)addJobsObject:(BWCDJob *)value;
- (void)removeJobsObject:(BWCDJob *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

@end
