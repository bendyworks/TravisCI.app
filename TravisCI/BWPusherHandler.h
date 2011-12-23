//
//  BWPusherHandler.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPusherDelegate.h"
#import "RestKit/RestKit.h"

@class PTPusher;

@interface BWPusherHandler : NSObject <PTPusherDelegate>
+ (id)pusherHandlerWithKey:(NSString *)apiKey;
- (id)initWithKey:(NSString *)apiKey;

@property (nonatomic, strong) PTPusher *client;
@end
