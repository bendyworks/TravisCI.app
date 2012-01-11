//
//  BWAppDelegate.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BWPusherHandler;

@interface BWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) BWPusherHandler *pusherHandler;

- (void)saveContext;
- (NSURL *)applicationCacheDirectory;

@end
