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
#import "BWBuild.h"
#import "NSString+BWTravisCI.h"

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
    return [[self.object valueForKey:@"finished_at"] distanceOfTimeInWords];
}


- (BWStatus)currentStatus
{
    if (self.status) {
        return (self.status == [NSNumber numberWithInt:0]) ? BWStatusPassed : BWStatusFailed;
    }
    return BWStatusPending;
}

- (NSString *)commit
{
    return self.build.commit;
}

- (NSString *)compare
{
    return self.build.compare_url;
}

- (NSString *)author
{
    return self.build.author_name;
}

- (NSString *)message
{
    return self.build.message;
}

- (NSString *)configString
{
    NSDictionary *configDict = [self.config subdictionaryWithoutKeys:@".configured", @"notifications", nil];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[configDict count]];
    for (NSString *key in configDict) {
        id value = [configDict valueForKey:key];
        [array addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
    }
    return [array componentsJoinedByString:@", "];
}

- (NSString *)lastLogLine
{
    return [self.log lastLine];
}

- (NSString *)logSubtitle
{
    NSUInteger numberOfLines = [[self.log componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]] count];
    return [NSString stringWithFormat:@"%d more lines previously", numberOfLines];
}

- (BWBuild *)build
{
    return [BWBuild presenterWithObject:[self.object valueForKey:@"build"]];
}

@end
