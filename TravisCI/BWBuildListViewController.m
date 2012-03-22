//
//  BWBuildListViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/9/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWBuildListViewController.h"
#import "BWRepository+All.h"
#import "BWBuild+All.h"
#import "BWBuildTableCell.h"
#import "BWJobListViewController.h"
#import "BWColor.h"
#import "BWFavoriteList.h"
#import "BWAppDelegate.h"
#import "CoreData.h"
#import "BWDetailContainerViewController.h"

@interface BWBuildListViewController ()
@property (nonatomic, retain) UIBarButtonItem *enabledStarButton;
@property (nonatomic, retain) UIBarButtonItem *disabledStarButton;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setNavigationTitleProperties:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)updateFollowButton;
@end

@implementation BWBuildListViewController
@synthesize repositoryName;
@synthesize authorName;

@synthesize enabledStarButton, disabledStarButton;

@synthesize fetchedResults = __fetchedResults;
@synthesize repository, jobListController, buildCellNib;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFollowButton) name:@"favoriteListUpdated" object:nil];
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

- (void)awakeFromNib
{
    [self.tableView setAccessibilityLabel:@"Builds"];
}

- (void)viewDidLoad
{
    self.enabledStarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"enabled_star"] style:UIBarButtonItemStyleBordered target:self action:@selector(askToToggleFavorite:)];
    self.disabledStarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"disabled_star"] style:UIBarButtonItemStyleBordered target:self action:@selector(askToToggleFavorite:)];
}

-(void)viewDidUnload
{
    [self setRepositoryName:nil];
    [self setAuthorName:nil];
    [super viewDidUnload];
    self.jobListController = nil;
    self.buildCellNib = nil;
    self.fetchedResults = nil;
    self.enabledStarButton = nil;
    self.disabledStarButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addObserver:self forKeyPath:@"repository" options:NSKeyValueObservingOptionNew context:nil];
    [self.authorName setText:[self.repository author]];
    [self.repositoryName setText:[self.repository name]];

    [self updateFollowButton];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNavigationTitleProperties:(UIInterfaceOrientation)[[UIDevice currentDevice] orientation]]; //bit of a hack... don't always assume deviceOrientation == interfaceOrientation!
}

- (void)setNavigationTitleProperties:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (IS_IOS_50) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            UIColor *tinColor = [UIColor colorWithRed:0.443f green:0.471f blue:0.502f alpha:1.0f];
            [self.authorName setTextColor:tinColor];
            [self.authorName setShadowColor:[UIColor whiteColor]];
            [self.authorName setShadowOffset:CGSizeMake(0.0f, 0.0f)];
            [self.repositoryName setTextColor:tinColor];
            [self.repositoryName setShadowColor:[UIColor whiteColor]];
            [self.repositoryName setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        } else {
            [self.authorName setTextColor:[UIColor whiteColor]];
            [self.authorName setShadowColor:[UIColor darkGrayColor]];
            [self.authorName setShadowOffset:CGSizeMake(0.0f, -1.0f)];
            [self.repositoryName setTextColor:[UIColor whiteColor]];
            [self.repositoryName setShadowColor:[UIColor darkGrayColor]];
            [self.repositoryName setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        }
    }

    if (IS_IPHONE && UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self.authorName setText:@""];
        [self.repositoryName setText:self.repository.slug];
    } else {
        [self.authorName setText:[self.repository author]];
        [self.repositoryName setText:[self.repository name]];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setNavigationTitleProperties:toInterfaceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"repository" context:nil];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

- (IBAction)askToToggleFavorite:(id)sender {
    NSString *titleText = nil;
    NSString *otherButtonText = nil;
    NSString *destructiveButtonText = nil;

    BWFavoriteList *favoriteList = ((BWAppDelegate *)[UIApplication sharedApplication].delegate).favoriteList;
    if ([favoriteList contains:self.repository.remote_id]) {
        titleText = @"Remove from Favorites?";
        destructiveButtonText = @"Remove";
    } else {
        titleText = @"Add to Favorites?";
        otherButtonText = @"Add";
    }

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:titleText delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonText otherButtonTitles:otherButtonText, nil];

    if ( (!IS_IOS_50) && IS_IPAD && UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {

        CGFloat buttonWidth = 55.0f;
        CGRect rect = CGRectMake(320.0-buttonWidth, -13.0, buttonWidth, 1.0);

        BWAppDelegate *appDelegate = (BWAppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *splitView = appDelegate.detailContainerViewController.view;

        [sheet showFromRect:rect inView:splitView animated:YES];
    } else {
        [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        BWFavoriteList *favoriteList = ((BWAppDelegate *)[UIApplication sharedApplication].delegate).favoriteList;
        if ([favoriteList contains:self.repository.remote_id]) {
            [favoriteList remove:self.repository.remote_id];
        } else {
            [favoriteList add:self.repository.remote_id];
        }

        [self updateFollowButton];
    }
}

- (void)updateFollowButton
{
    BWFavoriteList *favs = ((BWAppDelegate *)[UIApplication sharedApplication].delegate).favoriteList;
    if ([favs contains:self.repository.remote_id]) {
        [self.navigationItem setRightBarButtonItem:self.enabledStarButton];
    } else {
        [self.navigationItem setRightBarButtonItem:self.disabledStarButton];
    }
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
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [BWColor gradientViewForFrame:cell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(BWBuildTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BWCDBuild *build = [self.fetchedResults objectAtIndexPath:indexPath];

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
        BWCDBuild *build = [self.fetchedResults objectAtIndexPath:indexPath];
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

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
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
