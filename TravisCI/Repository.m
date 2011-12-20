//
//  Repository.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "Repository.h"
#import "Repository+Private.h"

@implementation Repository

@dynamic last_build_started_at;
@dynamic slug;
@dynamic remote_description;
@dynamic remote_id;
@dynamic last_build_id;
@dynamic last_build_number;
@dynamic last_build_finished_at;
@dynamic last_build_status;
@dynamic last_build_language;
@dynamic last_build_duration;
@dynamic last_build_result;

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
    NSTimeInterval duration = fabs([[self valueForKey:@"last_build_started_at"] timeIntervalSinceNow]);
    NSTimeInterval finished = fabs([[self valueForKey:@"last_build_finished_at"] timeIntervalSinceNow]);
    NSString *durationText = [NSString stringWithFormat:@"Duration: %f, Finished: %f", duration, finished];
    return durationText;
}

@end
