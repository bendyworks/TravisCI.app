//
//  BWCommandBuildFinished.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import "PTPusherEvent.h"

@interface BWCommandBuildFinished : NSObject

- (void)buildWasFinished:(PTPusherEvent *)event;

@end
