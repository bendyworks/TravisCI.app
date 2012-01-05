//
//  BWCommandBuildStarted.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/23/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWCommandBuildStarted.h"
#import "RestKit/RKObjectManager.h"
#import "RestKit/RKObjectMapping.h"
#import "RestKit/CoreData.h"

@implementation BWCommandBuildStarted

/*
 * JSON for 'build:started' on common:
 *
 *  build: Object
 *  - author_email: "larry@l2g.to"
 *  - author_name: "Lawrence Leonard "Larry" Gilbert"
 *  - branch: "master"
 *  - commit: "e5ef8fefc8f233c9eb0171a9aa7d145f335c920a"
 *  - committed_at: "2011-12-23T17:41:05Z"
 *  - committer_email: null
 *  - committer_name: null
 *  - compare_url: "https://github.com/L2G/vendorer/compare/dbb754d...e5ef8fe"
 *  - config: Object
 *  - id: 441336
 *  - message: "Don't raise an exception if Vendorfile is missing, just make a nice reminder message"
 *  - matrix: Array[3]
 *  - number: "5"
 *  - repository_id: 5227
 *  - result: null
 *  - started_at: "2011-12-23T17:41:09Z"
 *  repository: Object
 *  - description: "Vendorer keeps your dependencies documented and up to date"
 *  - id: 5227
 *  - last_build_duration: null
 *  - last_build_finished_at: null
 *  - last_build_id: 441336
 *  - last_build_language: null
 *  - last_build_number: "5"
 *  - last_build_result: null
 *  - last_build_started_at: "2011-12-23T17:41:09Z"
 *  - slug: "L2G/vendorer"
 *  started_at: "2011-12-23T17:41:09Z"
 */

- (void)buildWasStarted:(PTPusherEvent *)event
{
    //get the id and data to update
    NSDictionary *repositoryDictionary = [[event data] valueForKey:@"repository"];
    NSNumber *repository_id = [repositoryDictionary valueForKey:@"id"];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSManagedObjectContext *moc = [manager.objectStore managedObjectContext];
    NSManagedObject *repository = [manager.objectStore findOrCreateInstanceOfEntity:[NSEntityDescription entityForName:@"BWCDRepository" inManagedObjectContext:moc]
                                                      withPrimaryKeyAttribute:@"remote_id"
                                                                     andValue:repository_id];

    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:repositoryDictionary
                                                                               toObject:repository
                                                                            withMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"]];
    
    NSError *error = nil;
    [mappingOp performMapping:&error];

    [manager.objectStore save];
}

@end
