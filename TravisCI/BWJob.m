//
//  BWJob.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWJob.h"
#import "NSDictionary+BWTravisCI.h"
#import "NSDate+Formatting.h"

@interface BWJob()

-(NSDictionary *)config;

@end




@implementation BWJob

@dynamic log, number, result, state, status;


- (NSString *)language
{
    NSArray *languageAndVersion = [[self config] detectFromKeys:@"rvm", /* @"gemfile", @"env",*/ @"opt_release", @"php", @"node_js", nil];
    NSString *ret = [languageAndVersion componentsJoinedByString:@" "];
    return ret;
}

- (NSDictionary *)config
{
    return [self.object valueForKey:@"config"];
}

- (NSString *)env
{
    return [[self config] valueForKey:@"env"];
}

- (NSString *)durationText
{
//    NSNumber *duration = [self.object valueForKey:@"finished_at"] - [self.object valueForKey:@"started_at"];
    NSDate *finished_at = [self.object valueForKey:@"finished_at"];
    NSTimeInterval duration = [finished_at timeIntervalSinceDate:[self.object valueForKey:@"started_at"]];
    if (duration != 0) {
        return [NSDate rangeOfTimeInWordsFromSeconds:duration];
    } else {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self.object valueForKey:@"started_at"]];
        NSInteger timeSinceNow = [[NSNumber numberWithDouble:fabs(interval)] integerValue];
        return [NSDate rangeOfTimeInWordsFromSeconds:timeSinceNow];
    }

}

- (NSString *)finishedText
{
    return @"finished Text";
}

@end
