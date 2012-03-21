//
//  BWDetailContainerViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWDetailContainerViewController.h"
#import "BWRepositoryDetailViewController.h"
#import "BWPhoneJobDetailViewController.h"


@implementation BWDetailContainerViewController

@synthesize splashViewController = _splashViewController, repositoryDetailViewController = _repositoryDetailViewController, jobDetailViewController = _jobDetailViewController;
@synthesize masterPopoverController = _masterPopoverController;

- (void)awakeFromNib
{
    [self addChildViewController:self.splashViewController];
//    [self addChildViewController:self.repositoryDetailViewController];
    [self addChildViewController:self.jobDetailViewController];
    
    [self.view addSubview:self.splashViewController.view];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showJobDetailFor:(BWCDJob *)job
{
    UIView *view = [self.jobDetailViewController valueForKey:@"view"];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.jobDetailViewController setValue:job forKey:@"job"];

    [self transitionFromViewController:self.splashViewController
                      toViewController:self.jobDetailViewController
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {}];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.repositoryDetailViewController = nil;
    self.jobDetailViewController = nil;
    self.masterPopoverController = nil;
}

#pragma mark children views

- (UIViewController *)splashViewController
{
    if (_splashViewController == nil) {
        _splashViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SplashViewController"];
    }
    return _splashViewController;
}

- (BWRepositoryDetailViewController *)repositoryDetailViewController
{
    if (_repositoryDetailViewController == nil) {
        _repositoryDetailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"RepositoryDetailViewController"];
    }
    return _repositoryDetailViewController;
}

- (id)jobDetailViewController
{
    if (_jobDetailViewController == nil) {
        _jobDetailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    }
    return _jobDetailViewController;
}

#pragma mark split view delegate

// called when rotating to portrait (or launching in portrait)
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Repositories", @"Repositories");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

// called when rotating to landscape (or launching in landscape)
- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
