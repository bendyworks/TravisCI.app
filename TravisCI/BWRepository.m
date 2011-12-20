//
//  BWRepository.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWRepository.h"
#import "BWRepository+Private.h"

@implementation BWRepository
@synthesize object = _object;

+ (BWRepository *)repositoryWithManagedObject:(NSManagedObject *)obj
{
    return [[BWRepository alloc] initWithManagedObject:obj];
}

- (id)initWithManagedObject:(NSManagedObject *)obj
{
    self = [super init];
    if (self != nil) {
        self.object = obj;
    }
    return self;
}

- (NSString *)slug { return [self.object valueForKey:@"slug"]; }
- (NSString *)last_build_number { return [self.object valueForKey:@"last_build_number"]; }
- (NSNumber *)last_build_status { return [self.object valueForKey:@"last_build_status"]; }

- (NSString *)timingText
{
    return [NSString stringWithFormat:@"%@: %@, %@: %@",
            NSLocalizedString(@"Duration", nil),
            [self durationText],
            NSLocalizedString(@"Finished", nil),
            [self finishedText]];
}

- (NSString *)finishedText
{
    return @"";
}

- (NSString *)durationText
{
//    NSTimeInterval duration = fabs([[self valueForKey:@"last_build_started_at"] timeIntervalSinceNow]);
//    NSTimeInterval finished = fabs([[self valueForKey:@"last_build_finished_at"] timeIntervalSinceNow]);
//    NSString *durationText = [NSString stringWithFormat:@"Duration: %f, Finished: %f", duration, finished];
    NSString *durationText = @"hi";
    return durationText;
}

@end
