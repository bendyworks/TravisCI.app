//
//  BWCommandBuildFinished.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCommandBuildFinished.h"
#import "BWCDObjectMananger.h"


@implementation BWCommandBuildFinished



/*
 * Json from pusher event 'build:finished' on channel common:
 * {
 *   finished_at: "2012-01-05T20:13:09Z",
 *   status: 0,
 *   build: {
 *     finished_at: "2012-01-05T20:13:09Z"
 *     id: 482698
 *     result: 0
 *   },
 *   repository: {
 *     id: 1135
 *     last_build_duration: 193
 *     last_build_finished_at: "2012-01-05T20:13:09Z"
 *     last_build_id: 482698
 *     last_build_number: "121"
 *     last_build_result: 0
 *     last_build_started_at: "2012-01-05T20:09:56Z"
 *     slug: "vito/atomy"
 *   }
 * }
*/

- (void)buildWasFinished:(PTPusherEvent *)event
{
    NSDictionary *repositoryDictionary = [[event data] valueForKey:@"repository"];
    [BWCDObjectMananger updateRepositoryFromDictionary: repositoryDictionary];
}

@end
