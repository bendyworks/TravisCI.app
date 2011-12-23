//
//  BWCommandBuildStarted.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/23/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPusherEvent.h"

@class RKObjectMappingProvider;



@interface BWCommandBuildStarted : NSObject

- (void)buildWasStarted:(PTPusherEvent *)event;

@end
