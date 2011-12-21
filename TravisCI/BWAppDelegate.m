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

@implementation BWAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize pusherHandler = _pusherHandler;

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
    
    self.pusherHandler = [BWPusherHandler pusherHandlerWithKey:@"19623b7a28de248aef28"];
    
    return YES;
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


@end
