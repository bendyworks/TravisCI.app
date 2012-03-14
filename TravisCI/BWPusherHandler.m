//
//  BWPusherHandler.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWPusherHandler.h"
#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"
#import "BWCommandBuildStarted.h"
#import "BWCommandBuildFinished.h"
#import "BWCommandJobFinished.h"
#import "BWCommandJobLog.h"

#import "RestKit/RestKit.h"

#define PUSHER_EVENT_LOGGING 0



@interface BWPusherHandler()
- (void)setupPusherWithKey:(NSString *)apiKey;
@end



@implementation BWPusherHandler
@synthesize client, subscribedChannels;

+ (id)pusherHandlerWithKey:(NSString *)apiKey
{
    BWPusherHandler *pusherHandler = [[BWPusherHandler alloc] initWithKey:apiKey];
    return pusherHandler;
}

- (id)initWithKey:(NSString *)apiKey
{
    self = [super init];
    if (self != nil) {
        self.subscribedChannels = [NSMutableDictionary dictionary];
        [self setupPusherWithKey:apiKey];
    }
    return self;
}

- (void)setupPusherWithKey:(NSString *)apiKey
{
    self.client = [PTPusher pusherWithKey:apiKey delegate:(id <PTPusherDelegate>)[UIApplication sharedApplication].delegate encrypted:YES];
    self.client.reconnectAutomatically = YES;
    
    PTPusherChannel *channel = [self.client subscribeToChannelNamed:@"common"];
    
    [channel bindToEventNamed:@"build:started" target:[[BWCommandBuildStarted alloc] init] action:@selector(buildWasStarted:)];
    [channel bindToEventNamed:@"build:finished" target:[[BWCommandBuildFinished alloc] init] action:@selector(buildWasFinished:)];
    [channel bindToEventNamed:@"job:finished" target:[[BWCommandJobFinished alloc] init] action:@selector(jobWasFinished:)];

#if PUSHER_EVENT_LOGGING
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEvent:) name:PTPusherEventReceivedNotification object:channel];
#endif

}

- (void)subscribeToChannel:(NSString *)channelName
{
    PTPusherChannel *channel = [self.client subscribeToChannelNamed:channelName];
    [self.subscribedChannels setValue:channel forKey:channelName];

    [channel bindToEventNamed:@"job:log" target:[[BWCommandJobLog alloc] init] action:@selector(jobLogAppended:)];
}

- (void)unsubscribeFromChannel:(NSString *)channelName
{
    PTPusherChannel *channel = [self.subscribedChannels valueForKey:channelName];
    [self.subscribedChannels removeObjectForKey:channelName];

    [self.client unsubscribeFromChannel:channel];
}

// will only get called if PUSHER_EVENT_LOGGING is true
- (void)didReceiveEvent:(NSNotification *)note
{
    PTPusherEvent *event = (PTPusherEvent *)[[note userInfo] valueForKey:PTPusherEventUserInfoKey];
    NSLog(@"pusher - notification: %@", [event data]);
}

@end
