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
                              delegate:self];
}

- (BWStatus)currentStatus
{
    if (self.last_build_status != nil && self.last_build_finished_at) {
        return (self.last_build_status == [NSNumber numberWithInt:0]) ? BWStatusPassed : BWStatusFailed;
    }
    return BWStatusPending;
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    // objects == [build_1, build_2, ...]
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"buildsLoaded" object:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
