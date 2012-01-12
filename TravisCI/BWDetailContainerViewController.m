//
//  BWDetailContainerViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWDetailContainerViewController.h"
#import "BWRepositoryDetailViewController.h"

@interface BWDetailContainerViewController()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end


@implementation BWDetailContainerViewController

@synthesize splashViewController = _splashViewController, repositoryDetailViewController = _repositoryDetailViewController;
@synthesize masterPopoverController = _masterPopoverController;

- (void)awakeFromNib
{
    [self addChildViewController:self.splashViewController];
    [self addChildViewController:self.repositoryDetailViewController];
    
    [self.view addSubview:self.splashViewController.view];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
