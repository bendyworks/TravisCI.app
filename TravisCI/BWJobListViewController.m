//
//  BWJobTableView.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWJobListViewController.h"
#import "RestKit/CoreData.h"
#import "BWJob.h"
#import "BWJobTableCell.h"
#import "BWBuild.h"

@interface BWJobListViewController()

- (void)configureCell:(BWJobTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation BWJobListViewController


@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize jobCellNib, build;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"build" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"build" context:nil];
    [super viewDidUnload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; }

- (void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated]; }

- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated]; }

- (void)viewDidDisappear:(BOOL)animated { [super viewDidDisappear:animated]; }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return [[self.fetchedResultsController sections] count]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWJobTableCell *cell = [BWJobTableCell cellForTableView:tableView fromNib:self.jobCellNib];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(BWJobTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWJob *job = [BWJob presenterWithObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];

    NSString *statusImage = @"status_yellow";
    UIColor *textColor = [UIColor blackColor];
    if (job.status != nil) {
        if (job.status == [NSNumber numberWithInt:0]) {
            statusImage = @"status_green";
            textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
        } else {
            statusImage = @"status_red";
            textColor = [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f];
        }
    }
    
    [cell.buildIcon setImage:[UIImage imageNamed:statusImage]];
    [cell.number setText:job.number];
    [cell.number setTextColor:textColor];
    //    [cell.duration setText:job.duration_text];
    //    [cell.finished setText:job.duration_text];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
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

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
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


@end
