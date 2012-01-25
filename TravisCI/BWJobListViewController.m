//
//  BWJobTableView.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWAwesome.h"
#import "BWAppDelegate.h"
#import "BWJobListViewController.h"
#import "BWPhoneJobDetailViewController.h"
#import "BWDetailContainerViewController.h"
#import "RestKit/CoreData.h"
#import "BWJob.h"
#import "BWJobTableCell.h"
#import "BWBuild.h"
#import "BWColor.h"


@interface BWJobListViewController()

- (void)configureCell:(BWJobTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (BWJob *)jobAtIndexPath:(NSIndexPath *)indexPath;

@end


@implementation BWJobListViewController


@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize jobDetailViewController = _jobDetailViewController;
@synthesize jobCellNib, build;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

#pragma mark - View lifecycle

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self addObserver:self forKeyPath:@"build" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationItem.title = [NSString stringWithFormat:@"Build #%d", [self.build.number integerValue]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"build" context:nil];

    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    self.jobCellNib = nil;

    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return [[self.fetchedResultsController sections] count]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWJob *job = [self jobAtIndexPath:indexPath];
    if (job.env) {
        return 127.0f;
    } else {
        return 127.0f - 36.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWJobTableCell *cell = [BWJobTableCell cellForTableView:tableView fromNib:self.jobCellNib];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(BWJobTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWJob *job = [self jobAtIndexPath:indexPath];

    [cell.buildIcon setImage:job.statusImage];
    [cell.number setText:job.number];
    [cell.number setTextColor:job.statusTextColor];
    [cell.language setText:job.language];
    [cell.env setText:job.env];
    [cell.duration setText:job.durationText];
    [cell.finished_at setText:job.finishedText];
    cell.accessibilityLabel = job.accessibilityLabel;
    cell.accessibilityHint = job.accessibilityHint;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"showJobDetail" isEqualToString:segue.identifier]) {
        [[segue destinationViewController] setJob:sender];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWJob *job = [self jobAtIndexPath:indexPath];
    if (IS_IPAD) {
        BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
        BWDetailContainerViewController *detailContainer = appDelegate.detailContainerViewController;
        [detailContainer showJobDetailFor:job];
        [detailContainer.masterPopoverController dismissPopoverAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"showJobDetail" sender:job];
//        [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row % 2) == 0) {
        [cell setBackgroundColor:[BWColor cellTintColor]];
    }
}

- (UINib *)jobCellNib
{
    if (jobCellNib == nil) {
        self.jobCellNib = [BWJobTableCell nib];
    }
    return jobCellNib;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSManagedObjectContext *moc = [[RKObjectManager sharedManager].objectStore managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BWCDJob" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];

    NSPredicate *findByBuildId = [NSPredicate predicateWithFormat:@"build.remote_id = %@", self.build.remote_id];
    [fetchRequest setPredicate:findByBuildId];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES comparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2 options:kCFCompareNumerically];
    }];

    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:moc
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(BWJobTableCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (BWJob *)jobAtIndexPath:(NSIndexPath *)indexPath
{
    return [BWJob presenterWithObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
}

- (BWPhoneJobDetailViewController *)jobDetailViewController
{
    if (_jobDetailViewController) {
        return _jobDetailViewController;
    }
    _jobDetailViewController = [[BWPhoneJobDetailViewController alloc] init];
    return _jobDetailViewController;
}

@end
