//
//  BWCommandBuildStarted.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/23/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import "PTPusherEvent.h"

@class RKObjectMappingProvider;



@interface BWCommandBuildStarted : NSObject

- (void)buildWasStarted:(PTPusherEvent *)event;

@end
