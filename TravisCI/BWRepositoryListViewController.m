//
//  BWMasterViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWRepositoryListViewController.h"
#import "BWBuildListViewController.h"
#import "BWAwesome.h"
#import "BWRepositoryDataSource.h"

#import "BWRepository.h"

@interface BWRepositoryListViewController ()
- (void)refreshRepositoryList;
- (NSArray *)scopeButtonTitles;
@end

@implementation BWRepositoryListViewController

@synthesize repositoryDataSource = _repositoryDataSource;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize buildListController = _buildListController;

- (void)awakeFromNib
{
    if (IS_IPAD) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [self.tableView setAccessibilityLabel:@"Repositories"];
    [super awakeFromNib];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.detailViewController = (BWRepositoryViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated { 

    [super viewWillAppear:animated];
    [self.tableView setDataSource:self.repositoryDataSource];
    [self refreshRepositoryList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.buildListController = nil;
    self.repositoryDataSource = nil;
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"goToBuilds" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        BWRepository *repository = [BWRepository presenterWithObject:[[self repositoryDataSource] objectAtIndexPath:indexPath]];
        [repository fetchBuilds];
        [[segue destinationViewController] setValue:repository forKey:@"repository"];
        //[self.detailViewController configureViewAndSetRepository:repository];
    }

}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goToBuilds" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - Fetched results controller delegate

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
            [self.repositoryDataSource configureCell:(BWRepositoryTableCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)refreshRepositoryList
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    [manager loadObjectsAtResourcePath:@"/repositories.json"
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"]
                              delegate:nil];
}

- (BWRepositoryDataSource *)repositoryDataSource
{
    if ( ! _repositoryDataSource) {
        _repositoryDataSource = [BWRepositoryDataSource repositoryDataSourceWithFetchedResultsControllerDelegate:self];
    }
    return _repositoryDataSource;
}

- (NSArray *)scopeButtonTitles
{
    return [NSArray arrayWithObjects:@"All", @"Usernames", nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController.searchBar setScopeButtonTitles:[self scopeButtonTitles]];
    [self.searchDisplayController.searchBar setShowsScopeBar:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/repositories.json?search=%@", searchBar.text];
    [manager loadObjectsAtResourcePath:resourcePath
                         objectMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"]
                              delegate:nil];
}

#pragma mark Getters and Setters

- (BWBuildListViewController *)buildListController
{
    if (_buildListController != nil) {
        return _buildListController;
    }
    
    _buildListController = [[BWBuildListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    return _buildListController;
}

@end
