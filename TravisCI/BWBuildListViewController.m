//
//  BWBuildListViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWBuildListViewController.h"
#import "BWRepository.h"
#import "BWBuild.h"
#import "BWBuildTableCell.h"
#import "BWJobListViewController.h"
#import "BWColor.h"
#import "RestKit/CoreData.h"

@interface BWBuildListViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BWBuildListViewController

@synthesize fetchedResults = __fetchedResults;
@synthesize repository, jobListController, buildCellNib;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.fetchedResults = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"repository" options:NSKeyValueObservingOptionNew context:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self removeObserver:self forKeyPath:@"repository" context:nil];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.repository.slug;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark Custom cells

- (UINib *)buildCellNib
{
    if (buildCellNib == nil) {
        self.buildCellNib = [BWBuildTableCell nib];
    }
    return buildCellNib;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResults sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWBuildTableCell *cell = [BWBuildTableCell cellForTableView:tableView fromNib:self.buildCellNib];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(BWBuildTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWBuild *build = [BWBuild presenterWithObject:[self.fetchedResults objectAtIndexPath:indexPath]];
    NSString *buildNumber = [NSString stringWithFormat:@"Build #%@", build.number];
    [cell.buildNumber setText:buildNumber];
    [cell.commit setText:build.commit];
    [cell.message setText:build.message];

    NSString *statusImage = @"status_yellow";
    UIColor *textColor = [BWColor textColor];
    if (build.result) {
        if (build.result == [NSNumber numberWithInt:0]) {
            statusImage = @"status_green";
            textColor = [BWColor buildPassedColor];
        } else {
            statusImage = @"status_red";
            textColor = [BWColor buildFailedColor];
        }
    }
    [cell.buildNumber setTextColor:textColor];
    [cell.statusImage setImage:[UIImage imageNamed:statusImage]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.jobListController == nil) {
        self.jobListController = [[BWJobListViewController alloc] initWithStyle:UITableViewStylePlain];
    }

    BWBuild *build = [BWBuild presenterWithObject:[self.fetchedResults objectAtIndexPath:indexPath]];
    [build fetchJobs];
    // [self.detailViewController configureViewAndSetBuild:build];
    
    self.jobListController.build = build;
    [self.navigationController pushViewController:self.jobListController animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResults
{
    if (__fetchedResults != nil) {
        return __fetchedResults;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *moc = [[RKObjectManager sharedManager].objectStore managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BWCDBuild" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];

    NSPredicate *findByRepositoryId = [NSPredicate predicateWithFormat:@"repository.remote_id = %@", self.repository.remote_id];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];

    [fetchRequest setPredicate:findByRepositoryId];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSString *cacheName = [NSString stringWithFormat:@"BuildListForRepoID-%@", self.repository.remote_id];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResults = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResults performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResults;
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
