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
#import "BWPusherHandler.h"

@interface BWAppDelegate()
- (void)setupRestKit;
@end

@implementation BWAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize pusherHandler = _pusherHandler;

#define USE_ACTUAL_TRAVIS_CI_PUSHER_DATA 1
#define USE_ACTUAL_TRAVIS_CI_PUSHER_DATA 1

// these PUSHER_API_KEY values are not sensitive to exposure
#if USE_ACTUAL_TRAVIS_CI_PUSHER_DATA
  #define PUSHER_API_KEY @"23ed642e81512118260e"
#else
  #define PUSHER_API_KEY @"19623b7a28de248aef28"
#endif

#if USE_ACTUAL_TRAVIS_CI_PUSHER_DATA
    #define TRAVIS_CI_URL @"http://travis-ci.org"
#else
    #define TRAVIS_CI_URL @"http://localhost"
#endif


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self setupRestKit];

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

    self.pusherHandler = [BWPusherHandler pusherHandlerWithKey:PUSHER_API_KEY];

    return YES;
}

- (void)setupRestKit
{
    
    //    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:TRAVIS_CI_URL]; // sets up singleton shared object manager
    manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"TravisCI.sqlite"];
    manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;


    NSEntityDescription *repositoryDescription = [NSEntityDescription entityForName:@"BWCDRepository"
                                                             inManagedObjectContext:self.managedObjectContext];
    RKManagedObjectMapping *repositoryMapping = [RKManagedObjectMapping mappingForEntity:repositoryDescription];
    [repositoryMapping mapAttributes:@"slug", @"last_build_started_at", @"last_build_finished_at", @"last_build_duration", @"last_build_id", @"last_build_language", @"last_build_number", @"last_build_result", @"last_build_status", nil];
    [repositoryMapping mapKeyPath:@"id" toAttribute:@"remote_id"];
    [repositoryMapping mapKeyPath:@"description" toAttribute:@"remote_description"];
    repositoryMapping.primaryKeyAttribute = @"remote_id";

    [manager.mappingProvider setMapping:repositoryMapping forKeyPath:@"BWCDRepository"];

}
						
- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

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


@end
