//
//  BWCommandJobLog.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
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
