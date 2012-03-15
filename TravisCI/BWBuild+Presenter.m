//
//  BWBuild.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWBuild+Presenter.h"
#import "BWPresenter.h"
#import "CoreData.h"

@implementation BWCDBuild (Presenter)

PRESENT_statusImage
PRESENT_statusTextColor

- (void)fetchJobs
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/builds/%@.json", self.remote_id];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider mappingForKeyPath:@"BWCDBuild"]
                              delegate:nil];
}

- (NSString *)commit
{
    [self willAccessValueForKey:@"commit"];
    NSString *commit = [self primitiveValueForKey:@"commit"];
    [self didAccessValueForKey:@"commit"];

    [self willAccessValueForKey:@"branch"];
    NSString *branch = [self primitiveValueForKey:@"branch"];
    [self didAccessValueForKey:@"branch"];

    NSString *sha8 = [commit substringToIndex:8];
    NSString *shaAndBranch = [NSString stringWithFormat:@"%@ (%@)", sha8, branch];
    return shaAndBranch;
}

- (BWStatus)currentStatus
{
    if (self.result) {
        return (self.result == [NSNumber numberWithInt:0]) ? BWStatusPassed : BWStatusFailed;
    }
    return BWStatusPending;
}


- (NSString *)formattedNumber
{
    return [NSString stringWithFormat:@"Build #%@", self.number];
}

- (NSString *)accessibilityLabel
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
    return [NSString stringWithFormat:@"%@  %@", self.formattedNumber, __status];
}

- (NSString *)accessibilityHint
{
    return [NSString stringWithFormat:@"Commit message is \"%@\"", self.message];
}

@end
