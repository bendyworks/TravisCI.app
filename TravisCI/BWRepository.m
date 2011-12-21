//
//  BWRepository.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWRepository.h"
#import "BWRepository+Private.h"

#import "NSDate+Formatting.h"

@implementation BWRepository

- (NSString *)slug { return [self.object valueForKey:@"slug"]; }
- (NSString *)last_build_number { return [self.object valueForKey:@"last_build_number"]; }
- (NSNumber *)last_build_status { return [self.object valueForKey:@"last_build_status"]; }
- (NSNumber *)last_build_duration { return [self.object valueForKey:@"last_build_duration"]; }
- (NSDate *)last_build_started_at { return [self.object valueForKey:@"last_build_started_at"]; }
- (NSDate *)last_build_finished_at { return [self.object valueForKey:@"last_build_finished_at"]; }


- (NSString *)finishedText
{
    NSDate *finished = [self last_build_finished_at];
    if (finished != nil) {
        return [finished distanceOfTimeInWords];
    } else {
        return @"-";
    }
}

- (NSString *)durationText
{
    NSNumber *duration = [self last_build_duration];
    if (duration != nil) {
        return [NSDate rangeOfTimeInWordsFromSeconds:[duration intValue]];
    } else {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.last_build_started_at];
        NSInteger timeSinceNow = [[NSNumber numberWithDouble:fabs(interval)] integerValue];
        return [NSDate rangeOfTimeInWordsFromSeconds:timeSinceNow];
    }
}

@end
