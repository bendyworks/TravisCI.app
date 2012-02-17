//
//  BWRepositoryDataSource.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 2/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWRepositoryTableCell;

@interface BWRepositoryDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UINib *repositoryCellNib;

+ (id)repositoryDataSourceWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)_frcDelegate;

- (void)showAll;
- (void)searchAll:(NSString *)query;
- (void)searchUsername:(NSString *)query;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(BWRepositoryTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
