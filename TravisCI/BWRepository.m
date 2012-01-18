//
//  BWRepository.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWRepository.h"
#import "RestKit/RKObjectManager.h"

#import "NSDate+Formatting.h"

@implementation BWRepository

@dynamic remote_id, slug, last_build_number, last_build_status, last_build_duration, last_build_id, last_build_started_at, last_build_finished_at;

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

- (void)fetchBuilds
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/repositories/%@/builds.json", self.remote_id];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDBuild"]
                              delegate:nil];
}

- (BWStatus)currentStatus
{
    if (self.last_build_status != nil && self.last_build_finished_at) {
        return (self.last_build_status == [NSNumber numberWithInt:0]) ? BWStatusPassed : BWStatusFailed;
    }
    return BWStatusPending;
}

- (NSString *)accessibilityLabel
{
    NSArray *userAndRepo = [self.slug componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@ by %@", [userAndRepo objectAtIndex:1], [userAndRepo objectAtIndex:0]];
}

- (NSString *)accessibilityHint
{
    switch (self.currentStatus) {
        case BWStatusPending:
            return @"Most recent build is still building";
            break;
        case BWStatusPassed:
            return [NSString stringWithFormat:@"Most recent build passed %@ and took %@", self.finishedText, self.durationText];
            break;
        case BWStatusFailed:
            return [NSString stringWithFormat:@"Most recent build failed %@ and took %@", self.finishedText, self.durationText];
    }
    return @"";
}

@end
