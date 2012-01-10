//
//  BWMasterViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class BWBuildListViewController;

@interface BWRepositoryListViewController : UITableViewController <NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate>

@property (nonatomic, strong) UINib *repositoryCellNib;
@property (nonatomic, strong) BWBuildListViewController *buildListController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
