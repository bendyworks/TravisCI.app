//
//  BWRepository.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWRepository : NSObject

+ (BWRepository *)repositoryWithManagedObject:(NSManagedObject *)obj;
- (id)initWithManagedObject:(NSManagedObject *)obj;

- (NSString *)durationText;
- (NSString *)finishedText;

- (NSString *)slug;
- (NSString *)last_build_number;
- (NSNumber *)last_build_status;
- (NSNumber *)last_build_duration;
- (NSDate *)last_build_started_at;
- (NSDate *)last_build_finished_at;

@property (strong) id object;

@end
