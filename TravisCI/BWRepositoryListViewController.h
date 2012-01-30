//
//  BWMasterViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class BWBuildListViewController;

@interface BWRepositoryListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UINib *repositoryCellNib;
@property (nonatomic, strong) BWBuildListViewController *buildListController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
