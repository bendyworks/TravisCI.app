//
//  BWRepositoryDataSource.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 2/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWRepositoryDataSource.h"
#import "RestKit/RKObjectManager.h"
#import "RestKit/RKManagedObjectStore.h"
#import "BWRepositoryTableCell.h"
#import "BWRepository.h"
#import "BWColor.h"

@interface BWRepositoryDataSource ()
- (id)initWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)_frcDelegate;
- (UINib *)repositoryCellNib;
@end

@implementation BWRepositoryDataSource
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize repositoryCellNib;

#pragma mark initializer

+ (id)repositoryDataSourceWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)_frcDelegate
{
    return [[self alloc] initWithFetchedResultsControllerDelegate:_frcDelegate];
}

- (id)initWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)_frcDelegate
{
    self = [super init];
    if (self) {
        self.fetchedResultsController.delegate = _frcDelegate;

        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        NSLog(@"Error? %@", error);
    }
    return self;
}

#pragma mark API

- (void)showAll
{

}

- (void)searchAll:(NSString *)query
{
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug CONTAINS[cd] %@", query];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"ERROR! %@", error);
}

- (void)searchUsername:(NSString *)query
{

}

- (void)searchAllRemotely:(NSString *)query
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    NSString *resourcePath = [NSString stringWithFormat:@"/repositories.json?search=%@", query];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"]
                              delegate:nil];
}

- (void)searchUsernameRemotely:(NSString *)query
{

}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWRepositoryTableCell *cell = [BWRepositoryTableCell cellForTableView:tableView fromNib:self.repositoryCellNib];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return [[self.fetchedResultsController sections] count]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(BWRepositoryTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWRepository *repository = [BWRepository presenterWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    cell.slug.text = repository.slug;
    cell.buildNumber.text = [NSString stringWithFormat:@"#%@", repository.last_build_number];


    cell.duration.text = [repository durationText];
    cell.finished.text = [repository finishedText];

    [cell.slug setTextColor:repository.statusTextColor];
    [cell.buildNumber setTextColor:repository.statusTextColor];
    [cell.statusImage setImage:repository.statusImage];

    cell.accessibilityLabel = repository.accessibilityLabel;
    cell.accessibilityHint = repository.accessibilityHint;

    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [BWColor gradientViewForFrame:cell];
}

- (UINib *)repositoryCellNib
{
    if (repositoryCellNib == nil) {
        self.repositoryCellNib = [BWRepositoryTableCell nib];
    }
    return repositoryCellNib;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if ( ! _fetchedResultsController) {
        NSManagedObjectContext *moc = [[RKObjectManager sharedManager].objectStore managedObjectContext];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BWCDRepository"
                                                  inManagedObjectContext:moc];
        [fetchRequest setEntity:entity];

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_build_started_at" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];

        [fetchRequest setSortDescriptors:sortDescriptors];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }
    return _fetchedResultsController;
}

@end
