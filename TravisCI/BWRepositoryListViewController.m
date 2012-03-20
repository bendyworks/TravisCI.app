//
//  BWMasterViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWRepositoryListViewController.h"
#import "BWRepositoryTableCell.h"
#import "BWBuildListViewController.h"
#import "BWColor.h"
#import "BWAwesome.h"
#import "BWFavoriteList.h"
#import "BWAppDelegate.h"

#import "BWRepository+All.h"

@interface BWRepositoryListViewController ()
@property BOOL showingFavorites;
- (void)configureCell:(BWRepositoryTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)refreshRepositoryList;
- (void)refreshFavoritesList;
@end

@implementation BWRepositoryListViewController
@synthesize repositoryCellNib;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize buildListController = _buildListController;
@synthesize favoritesButton = _FavoritesButton;

@synthesize showingFavorites;

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
    self.showingFavorites = NO;
}

- (void)viewWillAppear:(BOOL)animated { 

    [super viewWillAppear:animated];

    [self refreshRepositoryList];

    if (self.showingFavorites) {
        [self showFavorites];
    } else {
        [self showAll];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

- (void)viewDidUnload
{
    [self setFavoritesButton:nil];
    [super viewDidUnload];
    self.buildListController = nil;
    self.repositoryCellNib = nil;
    self.fetchedResultsController = nil;
}

- (IBAction)tapFavorites:(id)sender
{
    if (self.showingFavorites) { // then show all
        [self showAll];
        self.favoritesButton.title = @"Favorites";
        self.navigationItem.title = @"All Repositories";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"favoriteListDidChange" object:nil];
    } else { // then show favorites
        [self refreshFavoritesList];
        [self showFavorites];
        self.favoritesButton.title = @"All";
        self.navigationItem.title = @"Favorites";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteListDidChange) name:@"favoriteListDidChange" object:nil];
    }
}

#pragma mark - Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return [[self.fetchedResultsController sections] count]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BWRepositoryTableCell *cell = [BWRepositoryTableCell cellForTableView:tableView fromNib:self.repositoryCellNib];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"goToBuilds" isEqualToString:segue.identifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        BWCDRepository *repository = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [repository fetchBuilds];
        [[segue destinationViewController] setValue:repository forKey:@"repository"];
        //[self.detailViewController configureViewAndSetRepository:repository];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goToBuilds" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (UINib *)repositoryCellNib
{
    if (repositoryCellNib == nil) {
        self.repositoryCellNib = [BWRepositoryTableCell nib];
    }
    return repositoryCellNib;
}

#pragma mark - Fetched results controller

- (void)favoriteListDidChange
{
    [self setFetchRequestToFavorites];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)setFetchRequestToFavorites
{
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    
    BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *remote_ids = [appDelegate.favoriteList.all array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remote_id IN %@", remote_ids];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

- (void)showFavorites
{
    [self setFetchRequestToFavorites];
    [self.tableView reloadData];

    self.showingFavorites = YES;
}

- (void)setFetchRequestToAll
{
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    
    [fetchRequest setPredicate:nil];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

- (void)showAll
{
    [self setFetchRequestToAll];
    [self.tableView reloadData];

    self.showingFavorites = NO;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BWCDRepository" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_build_started_at" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    return fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [self fetchRequest];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return __fetchedResultsController;
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
            [self configureCell:(BWRepositoryTableCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)configureCell:(BWRepositoryTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWCDRepository *repository = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (void)refreshRepositoryList
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    [manager loadObjectsAtResourcePath:@"/repositories.json"
                         objectMapping:[manager.mappingProvider mappingForKeyPath:@"BWCDRepository"]
                              delegate:nil];
}

- (void)refreshFavoritesList
{
    BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *remote_ids = [appDelegate.favoriteList.all array];
    RKObjectManager *manager = [RKObjectManager sharedManager];

    for (NSNumber *remote_id in remote_ids) {
        [manager loadObjectsAtResourcePath:@"/repositories.json"
                             objectMapping:[manager.mappingProvider mappingForKeyPath:@"BWCDRepository"]
                                  delegate:nil];
    }

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
