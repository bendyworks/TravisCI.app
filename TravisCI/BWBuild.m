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

@dynamic state, remote_id, number, author_email, author_name, commit, committer_name, compare_url, message, repository_id;

- (void)fetchJobs
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/builds/%@.json", self.remote_id];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDJob"]
                              delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"fie!");
}

@end
