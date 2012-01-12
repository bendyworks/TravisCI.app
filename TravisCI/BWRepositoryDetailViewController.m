//
//  BWRepositoryDetailViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/11/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWRepositoryDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BWRepositoryDetailViewController()
- (void)showLoadingIndicator;
- (void)dismissSplashScreen:(NSNotification *)notification;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation BWRepositoryDetailViewController

@synthesize splashView, masterPopoverController;

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSplashScreen:) name:@"buildsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingIndicator) name:@"repositorySelected" object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    if (self.splashView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"BWSplashView" owner:self options:nil];
        UIView *loadingIndicator = [self.splashView viewWithTag:1];
        loadingIndicator.layer.cornerRadius = 8.0f;
        loadingIndicator.layer.masksToBounds  = YES;

        [self.view addSubview:self.splashView];
    }
}

- (void)showLoadingIndicator
{
    [self.splashView viewWithTag:1].hidden = NO;
}

- (void)dismissSplashScreen:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2
                     animations:^{self.splashView.alpha = 0.0;}
                     completion:^(BOOL finished){ [self.splashView removeFromSuperview]; self.splashView = nil;}];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"buildsLoaded" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
