//
//  BWCommandBuildStarted.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/23/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCommandBuildStarted.h"
#import "RKObjectManager.h"
#import "RKObjectMapping.h"
#import "BWCDObjectMananger.h"

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
    NSDictionary *repositoryDictionary = [[event data] valueForKey:@"repository"];
    [BWCDObjectMananger updateRepositoryFromDictionary: repositoryDictionary];
}

@end
