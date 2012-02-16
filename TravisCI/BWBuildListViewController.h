//
//  BWBuildListViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

@class BWRepository, BWJobListViewController;

@interface BWBuildListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UINib *buildCellNib;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResults;
@property (nonatomic, strong) BWRepository *repository;
@property (nonatomic, strong) BWJobListViewController *jobListController;
@property (strong, nonatomic) IBOutlet UILabel *repositoryName;
@property (strong, nonatomic) IBOutlet UILabel *authorName;

@end
