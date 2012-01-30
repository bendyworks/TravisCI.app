//
//  BWBuildListViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWBuildListViewController.h"
#import "BWRepository.h"
#import "BWBuild.h"
#import "BWBuildTableCell.h"
#import "BWJobListViewController.h"
#import "BWColor.h"
#import "BWAwesome.h"
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
        if (IS_IPAD) {
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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self addObserver:self forKeyPath:@"repository" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationItem.title = self.repository.slug;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"repository" context:nil];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.jobListController = nil;
    self.buildCellNib = nil;
    self.fetchedResults = nil;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

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

    [cell.buildNumber setText:build.formattedNumber];
    [cell.commit setText:build.commit];
    [cell.message setText:build.message];
    [cell.buildNumber setTextColor:build.statusTextColor];
    [cell.statusImage setImage:build.statusImage];
    [cell setAccessibilityLabel:build.accessibilityLabel];
    [cell setAccessibilityHint:build.accessibilityHint];
}

#pragma mark - Table view delegate


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"goToJobList" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        BWBuild *build = [BWBuild presenterWithObject:[self.fetchedResults objectAtIndexPath:indexPath]];
        [build fetchJobs];
        // [self.detailViewController configureViewAndSetBuild:build];

        [[segue destinationViewController] setValue:build forKey:@"build"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goToJobList" sender:[tableView cellForRowAtIndexPath:indexPath]];
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller { [self.tableView beginUpdates]; }
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller  { [self.tableView endUpdates];   }

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


@end
