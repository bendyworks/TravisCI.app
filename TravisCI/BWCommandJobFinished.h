//
//  BWCommandJobFinished.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPusherEvent.h"

@interface BWCommandJobFinished : NSObject

- (void)jobWasFinished:(PTPusherEvent *)event;

@end
