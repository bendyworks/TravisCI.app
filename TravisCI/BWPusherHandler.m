//
//  BWPusherHandler.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWPusherHandler.h"
#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"

#import "RestKit/RestKit.h"

#import "BWAppDelegate.h" //to remove
#import "BWRepositoryListViewController.h"

@interface BWPusherHandler()

@property (nonatomic, strong) RKManagedObjectMapping *jobMapping;

- (void)jobWasStarted:(PTPusherEvent *)event;
@end

@implementation BWPusherHandler
@synthesize client;
@synthesize jobMapping = _jobMapping;

+ (id)pusherHandlerWithKey:(NSString *)apiKey
{
    BWPusherHandler *pusherHandler = [[BWPusherHandler alloc] initWithKey:apiKey];
    return pusherHandler;
}

- (id)initWithKey:(NSString *)apiKey
{
    self = [super init];
    if (self != nil) {
        self.client = [PTPusher pusherWithKey:apiKey delegate:self];
        self.client.reconnectAutomatically = YES;
        
        PTPusherChannel *channel = [self.client subscribeToChannelNamed:@"common"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEvent:) name:PTPusherEventReceivedNotification object:channel];
        
        [channel bindToEventNamed:@"job:started" target:self action:@selector(jobWasStarted:)];
    }
    return self;
}

- (void)didReceiveEvent:(NSNotification *)note
{
    PTPusherEvent *event = (PTPusherEvent *)[[note userInfo] valueForKey:PTPusherEventUserInfoKey];
    NSLog(@"pusher - notification: %@", [event data]);
}

#pragma mark - Travis-specific callbacks

/**
 *  {
 *    build_id: int
 *    id: int
 *    started_at: date-time encoded as string
 *    state: string ("started")
 *  }
 **/
- (void)jobWasStarted:(PTPusherEvent *)event
{
    BWAppDelegate *appDel = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *masterNavController = [((UISplitViewController*)appDel.window.rootViewController).viewControllers objectAtIndex:0];
    BWRepositoryListViewController *controller = (BWRepositoryListViewController *)masterNavController.topViewController;
    [controller refreshRepositoryList];
    
//    NSInteger job_id = [[event.data valueForKey:@"id"] intValue];
//    RKObjectManager *manager = [RKObjectManager sharedManager];
//
//    NSString *jobURI = [NSString stringWithFormat:@"/jobs/%d.json", job_id];
//    [manager loadObjectsAtResourcePath:jobURI objectMapping:[self jobMapping] delegate:self];
}

-(RKObjectMapping *)jobMapping
{
    NSLog(@"Trace - entering jobMapping");
    if (_jobMapping != nil) {
        return _jobMapping;
    }

    RKObjectManager *manager = [RKObjectManager sharedManager];
    _jobMapping = [RKManagedObjectMapping mappingForEntityWithName:@"BWCDJob"];
    NSArray *attrs = [NSArray arrayWithObjects:@"finished_at", @"log", @"number", @"result", @"started_at", @"state", @"status", nil];

    for (NSString *attr in attrs) {
        [_jobMapping mapKeyPath:attr toAttribute:attr];
    }

    [_jobMapping mapKeyPath:@"id" toAttribute:@"remote_id"];

    _jobMapping.primaryKeyAttribute = @"remote_id";
    [manager.mappingProvider setMapping:_jobMapping forKeyPath:@"BWCDJob"]; // this doesn't seem right

    NSLog(@"Trace - exiting jobMapping");
    return _jobMapping;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"objectLoader didFailWithError: %@", error);
}


// TODO: extract into SingleJobHandler
// object is an NSManagedObject
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{

}

#pragma mark - Pusher Delegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection;
{
    NSLog(@"pusher - did connect: %@", connection);
}

- (void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection;
{
    NSLog(@"pusher - did disconnect: %@", connection);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error;
{
    NSLog(@"pusher - failed with error: %@", error);
}

- (void)pusher:(PTPusher *)pusher connectionWillReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay;
{
    NSLog(@"pusher - connection will reconnect after delay: %f", delay);
}

/** Notifies the delegate of the request that will be used to authorize access to a channel.
 
 When using the Pusher Javascript client, authorization typically relies on an existing session cookie
 on the server; when the Javascript client makes an AJAX POST to the server, the server can return
 the user's credentials based on their current session.
 
 When using libPusher, there will likely be no existing server-side session; authorization will
 need to happen by some other means (e.g. an authorization token or HTTP basic auth).
 
 By implementing this delegate method, you will be able to set any credentials as necessary by
 modifying the request as required (such as setting POST parameters or headers).
 */
- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request;
{
    NSLog(@"pusher - will authorize channel with request: %@", request);
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel;
{
    NSLog(@"pusher - did subscribe to channel: %@", channel);
}

- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel;
{
    NSLog(@"pusher - did unsubscribe from channel: %@", channel);
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error;
{
    NSLog(@"pusher - did fail to subscribe to channel: %@\npusher - with error: %@", channel, error);
}

@end
