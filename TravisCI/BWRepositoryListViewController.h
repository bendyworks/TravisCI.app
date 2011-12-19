//
//  BWMasterViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWRepositoryViewController;

#import <CoreData/CoreData.h>

@interface BWRepositoryListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) BWRepositoryViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
