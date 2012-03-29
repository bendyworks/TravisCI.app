//
//  BWJob.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWAppDelegate.h"
#import "BWJob+Presenter.h"
#import "NSDictionary+BWTravisCI.h"
#import "NSDate+Formatting.h"
#import "BWCDBuild.h"
#import "BWCDBuild.h"
#import "NSString+BWTravisCI.h"
#import "BWPresenter.h"

@interface BWCDJob (Presenter)
- (BWStatus)currentStatus;
@end

@implementation BWCDJob (Presenter)

PRESENT_statusImage
PRESENT_statusTextColor

- (NSString *)language
{
    NSArray *languageAndVersion = [[self config] detectFromKeys:@"rvm", /* @"gemfile", @"env",*/ @"opt_release", @"php", @"node_js", nil];
    NSString *ret = [languageAndVersion componentsJoinedByString:@" "];
    return ret;
}

- (NSDictionary *)config
{
    [self willAccessValueForKey:@"config"];
    NSDictionary *configDict = [[self primitiveValueForKey:@"config"] subdictionaryWithoutKeys:@".configured", @"notifications", nil];
    [self didAccessValueForKey:@"config"];
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
    NSDate *finished_at = [self valueForKey:@"finished_at"];
    NSTimeInterval duration = [finished_at timeIntervalSinceDate:[self valueForKey:@"started_at"]];
    if (duration != 0) {
        return [NSDate rangeOfTimeInWordsFromSeconds:duration];
    } else {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self valueForKey:@"started_at"]];
        NSInteger timeSinceNow = [[NSNumber numberWithDouble:fabs(interval)] integerValue];
        return [NSDate rangeOfTimeInWordsFromSeconds:timeSinceNow];
    }

}

- (NSString *)finishedText
{
    return [[self valueForKey:@"finished_at"] distanceOfTimeInWords];
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

- (NSString *)log
{
    [self willAccessValueForKey:@"log"];
    NSString *ret = [self primitiveValueForKey:@"log"];
    [self didAccessValueForKey:@"log"];
    return [ret stringBySimulatingCarriageReturn];
}

- (NSString *)lastLogLine
{
    return [self.log lastLine];
}

- (NSString *)logSubtitle
{
    NSUInteger numberOfLines = [self.log numberOfNewlines];
    return [NSString stringWithFormat:@"%d more lines previously", numberOfLines];
}

- (NSString *)formattedNumberOfLinesInLog
{
    NSUInteger lines = [self.log numberOfNewlines] + 1;
    return [NSString stringWithFormat:@"%d lines", lines];
}

- (BWCDBuild *)build
{
    [self willAccessValueForKey:@"build"];
    BWCDBuild *ret = [self primitiveValueForKey:@"build"];
    [self didAccessValueForKey:@"build"];
    return ret;
}

- (void)fetchDetails
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    NSString *resourcePath = [NSString stringWithFormat:@"/jobs/%@.json", self.remote_id];
    // do not set delegate to self. If self is a property of a view controller that gets dealloc'ed before
    // the request is finished, the app will crash with EXC_BAD_ACCESS
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider mappingForKeyPath:@"BWCDJob"]
                              delegate:nil];
}

- (void)fetchDetailsIfNeeded
{    
    if (([self.log length] < 1)     ||
        ([self.number length] < 1)  ||
        self.config == nil          ||
        ([self.compare length] < 1) ||
        ([self.author length] < 1)  ||
        ([self.message length] < 1)) {
        [self fetchDetails];
    }
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

- (NSString *)accessibilityLabel
{
    return [NSString stringWithFormat:@"Job %@ for %@", self.number, self.language];
}

- (NSString *)accessibilityHint
{
    NSString *__status;
    switch (self.currentStatus) {
        case BWStatusPending:
            __status = @"is still building";
            break;
        case BWStatusPassed:
            __status = @"passed";
            break;
        case BWStatusFailed:
            __status = @"failed";
            break;
    }
    return [NSString stringWithFormat:@"%@ %@", self.number, __status];
}

@end
