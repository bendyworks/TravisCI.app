//
//  BWJobTableView.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWBuild, BWPhoneJobDetailViewController;

@interface BWJobListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UINib *jobCellNib;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) BWBuild *build;
@property (readonly, strong) BWPhoneJobDetailViewController *jobDetailViewController;

@end
