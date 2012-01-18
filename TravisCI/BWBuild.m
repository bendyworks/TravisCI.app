//
//  BWBuild.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWBuild.h"
#import "RestKit/CoreData.h"

@implementation BWBuild

@dynamic state, result, remote_id, number, author_email, author_name, commit, committer_name, compare_url, message, repository_id;

- (void)fetchJobs
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/builds/%@.json", self.remote_id];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDBuild"]
                              delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"object loader failed with error: %@", error);
}

- (NSString *)commit
{
    NSString *sha8 = [(NSString *)[self.object valueForKey:@"commit"] substringToIndex:8];
    NSString *shaAndBranch = [NSString stringWithFormat:@"%@ (%@)", sha8, [self.object valueForKey:@"branch"]];
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
