//
//  BWCommandJobLog.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import "PTPusherEvent.h"

@interface BWCommandJobLog : NSObject

- (void)jobLogAppended:(PTPusherEvent *)event;

@end
