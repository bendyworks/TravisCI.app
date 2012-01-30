//
//  BWCommandJobLog.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCommandJobLog.h"
#import "BWCDObjectMananger.h"

@implementation BWCommandJobLog

- (void)jobLogAppended:(PTPusherEvent *)event
{
    NSDictionary *logDictionary = [event data];
    [BWCDObjectMananger appendToJobLog:logDictionary];
}


@end
