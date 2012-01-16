//
//  BWDetailContainerViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWDetailContainerViewController.h"
#import "BWRepositoryDetailViewController.h"
#import "BWPhoneJobDetailViewController.h"

@interface BWDetailContainerViewController()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end


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

- (void)showJobDetailFor:(BWJob *)job
{
    self.jobDetailViewController.job = job;

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
    // Return YES for supported orientations
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

- (BWPhoneJobDetailViewController *)jobDetailViewController
{
    if (_jobDetailViewController == nil) {
        _jobDetailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    }
    return _jobDetailViewController;
}

#pragma mark split view delegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Repositories", @"Repositories");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
