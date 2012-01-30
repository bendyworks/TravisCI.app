//
//  BWPusherHandler.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import "PTPusherDelegate.h"
#import "RestKit/RestKit.h"

@class PTPusher;

@interface BWPusherHandler : NSObject
+ (id)pusherHandlerWithKey:(NSString *)apiKey;
- (id)initWithKey:(NSString *)apiKey;

- (void)subscribeToChannel:(NSString *)channelName;
- (void)unsubscribeFromChannel:(NSString *)channelName;

@property (nonatomic, strong) PTPusher *client;
@property (nonatomic, strong) NSMutableDictionary *subscribedChannels;
@end
