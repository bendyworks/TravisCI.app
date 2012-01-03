//
//  BWDetailViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWRepositoryViewController.h"

@interface BWRepositoryViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation BWRepositoryViewController

@synthesize repository = _repository;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize repositoryNameLabel;
@synthesize buildNumberLabel;
@synthesize finishedLabel;
@synthesize durationLabel;
@synthesize commitLabel;
@synthesize compareLabel;
@synthesize authorLabel;
@synthesize committerLabel;
@synthesize messageLabel;
@synthesize configLabel;
@synthesize statusImage;

#pragma mark - Managing the detail item

- (void)setRepository:(BWRepository *)newRepository
{
    if (_repository != newRepository) {
        _repository = newRepository;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.repository) {
        self.title = self.repository.slug;
        self.repositoryNameLabel.text = self.repository.slug;
        self.buildNumberLabel.text = self.repository.last_build_number;
        self.finishedLabel.text = self.repository.finishedText;
        self.durationLabel.text = self.repository.durationText;
//        self.commitLabel.text = [self.build ??];
//        self.compareLabel.text = [self.build ??];
//        self.authorLabel.text = [self.build ??];
//        self.committerLabel.text = [self.build ??];
//        self.messageLabel.text = [self.build ??];
//        self.configLabel.text = [self.build ??];

        NSString *statusImageName = @"status_yellow";
        UIColor *textColor = [UIColor blackColor];
        if (self.repository.last_build_status != nil) {
            if (self.repository.last_build_status == [NSNumber numberWithInt:0]) {
                statusImageName = @"status_green";
                textColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f];
            } else {
                statusImageName = @"status_red";
                textColor = [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f];
            }
        }
        [self.buildNumberLabel setTextColor:textColor];
        [self.statusImage setImage:[UIImage imageNamed:statusImageName]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; }
- (void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated]; }
- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated]; }
- (void)viewDidDisappear:(BOOL)animated { [super viewDidDisappear:animated]; }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

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
