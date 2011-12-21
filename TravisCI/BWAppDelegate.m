//
//  BWAppDelegate.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWAppDelegate.h"
#import "BWRepositoryListViewController.h"
#import <RestKit/RestKit.h>
#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"

@interface BWAppDelegate()
- (void)didReceiveEvent:(NSNotification *)note;
@end

@implementation BWAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize pusher = _pusher;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);

    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:@"http://travis-ci.org"]; // Initialize singleton RestKit Object Manager
    manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"TravisCI.sqlite"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
        BWRepositoryListViewController *controller = (BWRepositoryListViewController *)masterNavigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        BWRepositoryListViewController *controller = (BWRepositoryListViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    self.pusher = [PTPusher pusherWithKey:@"19623b7a28de248aef28" delegate:self encrypted:NO];
    self.pusher.reconnectAutomatically = YES;

    PTPusherChannel *channel = [self.pusher subscribeToChannelNamed:@"common"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEvent:) name:PTPusherEventReceivedNotification object:channel];
    
    
    return YES;
}

- (void)didReceiveEvent:(NSNotification *)note
{
    PTPusherEvent *event = (PTPusherEvent *)[[note userInfo] valueForKey:PTPusherEventUserInfoKey];
    NSLog(@"pusher - notification: %@", [[event data] valueForKey:@"data"]);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) { return __managedObjectContext; }
    __managedObjectContext = [[RKObjectManager sharedManager].objectStore managedObjectContext];
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) { return __managedObjectModel; }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TravisCI" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TravisCI.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *lightweightMigrationDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                              [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                              nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:lightweightMigrationDict error:&error])
    {
        /*
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Pusher Delegate methods

/** Notifies the delegate that the PTPusher instance has connected to the Pusher service successfully.
 
 @param pusher The PTPusher instance that has connected.
 @param connection The connection for the pusher instance.
 */
- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection;
{
    NSLog(@"pusher - did connect: %@", connection);
}

/** Notifies the delegate that the PTPusher instance has disconnected from the Pusher service.
 
 @param pusher The PTPusher instance that has connected.
 @param connection The connection for the pusher instance.
 */
- (void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection;
{
    NSLog(@"pusher - did disconnect: %@", connection);
}

/** Notifies the delegate that the PTPusher instance failed to connect to the Pusher service.
 
 If reconnectAutomatically is YES, PTPusher will attempt to reconnect if the initial connection failed.
 
 This reconnect attempt will happen after this message is sent to the delegate, giving the delegate
 a chance to inspect the connection error and disable automatic reconnection if it thinks the reconnection
 attempt is likely to fail, depending on the error.
 
 @param pusher The PTPusher instance that has connected.
 @param connection The connection for the pusher instance.
 @param error The connection error.
 */
- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error;
{
    NSLog(@"pusher - failed with error: %@", error);
}

/** Notifies the delegate that the PTPusher instance is about to attempt reconnection.
 
 You may wish to use this method to keep track of the number of reconnection attempts and abort after a fixed number.
 
 If you do not set the `reconnectAutomatically` property of the PTPusher instance to NO, it will continue attempting
 to reconnect until a successful connection has been established.
 
 @param pusher The PTPusher instance that has connected.
 @param connection The connection for the pusher instance.
 */
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

/** Notifies the delegate that the PTPusher instance has subscribed to the specified channel.
 
 This method will be called after any channel authorization has taken place and when a subscribe event has been received.
 
 @param pusher The PTPusher instance that has connected.
 @param channel The channel that was subscribed to.
 */
- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel;
{
    NSLog(@"pusher - did subscribe to channel: %@", channel);
}

/** Notifies the delegate that the PTPusher instance has unsubscribed from the specified channel.
 
 This method will be called immediately after unsubscribing from a channel.
 
 @param pusher The PTPusher instance that has connected.
 @param channel The channel that was unsubscribed from.
 */
- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel;
{
    NSLog(@"pusher - did unsubscribe from channel: %@", channel);
}

/** Notifies the delegate that the PTPusher instance failed to subscribe to the specified channel.
 
 The most common reason for subscribing failing is authorization failing for private/presence channels.
 
 @param pusher The PTPusher instance that has connected.
 @param channel The channel that was subscribed to.
 @param error The error returned when attempting to subscribe.
 */
- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error;
{
    NSLog(@"pusher - did fail to subscribe to channel: %@\npusher - with error: %@", channel, error);
}

@end
