//
//  BWJobTableView.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWJobListViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) UINib *jobCellNib;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
