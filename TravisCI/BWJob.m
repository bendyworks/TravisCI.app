//
//  BWJob.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWAppDelegate.h"
#import "BWJob.h"
#import "NSDictionary+BWTravisCI.h"
#import "NSDate+Formatting.h"
#import "BWBuild.h"
#import "NSString+BWTravisCI.h"

@implementation BWJob

@dynamic log, number, result, state, status, remote_id;


- (NSString *)language
{
    NSArray *languageAndVersion = [[self config] detectFromKeys:@"rvm", /* @"gemfile", @"env",*/ @"opt_release", @"php", @"node_js", nil];
    NSString *ret = [languageAndVersion componentsJoinedByString:@" "];
    return ret;
}

- (NSDictionary *)config
{
    NSDictionary *configDict = [[self.object valueForKey:@"config"] subdictionaryWithoutKeys:@".configured", @"notifications", nil];
    return configDict;
}

- (NSString *)configString
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self.config count]];
    for (NSString *key in self.config) {
        id value = [self.config valueForKey:key];
        [array addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
    }
    return [array componentsJoinedByString:@", "];
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

- (void)fetchDetails
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    NSString *resourcePath = [NSString stringWithFormat:@"/jobs/%@.json", self.remote_id];
    // do not set delegate to self. If self is a property of a view controller that gets dealloc'ed before
    // the request is finished, the app will crash with EXC_BAD_ACCESS
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDJob"]
                              delegate:nil];
}

- (void)subscribeToLogUpdates
{
    BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate subscribeToLogChannelForJob:self];
}

- (void)unsubscribeFromLogUpdates
{
    BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate unsubscribeFromLogChannelForJob:self];
}

@end
