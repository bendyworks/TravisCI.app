//
//  BWPadJobDetailViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/16/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWPadJobDetailViewController.h"
#import "BWJob.h"
#import "BWEnumerableTableViewController.h"
#import "BWPadJobDetailHalfViewController.h"

@interface BWPadJobDetailViewController ()
- (BWPadJobDetailViewController *)jobDetail1;
- (BWPadJobDetailViewController *)jobDetail2;
- (void)configureView;
- (void)configureLogView;
- (void)configureViewWithoutLog;
- (void)doLayout;
@end

@implementation BWPadJobDetailViewController

@synthesize toolbar, largeTextArea, largeTextAreaToggle;
@synthesize job;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self doLayout];

    NSKeyValueObservingOptions newAndOld = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self addObserver:self forKeyPath:@"job" options:newAndOld context:nil];
    [self addObserver:self forKeyPath:@"job.object.log" options:NSKeyValueObservingOptionNew context:nil];

    [self.largeTextAreaToggle addTarget:self
                                 action:@selector(switchLargeTextArea:)
                       forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.jobDetail2.view setNeedsLayout];

    [self.job fetchDetails];

    [self configureView];
}

- (void)configureView
{
    [self configureViewWithoutLog];
    [self configureLogView];
}

- (void) configureViewWithoutLog
{
    [self.finishedLabel setText:[self.job finishedText]];
    [self.durationLabel setText:[self.job durationText]];
    [self.commitLabel setText:self.job.commit];
    [self.compareLabel setText:self.job.compare];
    [self.authorLabel setText:self.job.author];
    [self.messageLabel setText:self.job.message];
    [self.configLabel setText:self.job.configString];
    
    [self.parentViewController setTitle:[NSString stringWithFormat:@"Job #%@", self.job.number]];
}

- (void)configureLogView
{
    if (self.largeTextAreaToggle.selectedSegmentIndex == 0) {
        [self.largeTextArea setText:job.log];
    }
}

// There is an unwanted "snap" on the right table (jobDetail2) when you:
//   * start the app in landscape
//   * show this viewcontroller
//   * switch to portrait
// PDI
- (void)doLayout
{
    UITableViewController *jobDetail1 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail1"];
    UITableViewController *jobDetail2 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail2"];

    [self addChildViewController:jobDetail1];
    [self addChildViewController:jobDetail2];

    [self.view addSubview:jobDetail1.view];
    [self.view addSubview:jobDetail2.view];

    jobDetail1.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    jobDetail2.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;

    CGFloat width = (768.0f) / 2.0f;
    CGFloat height = 154.0f;
    CGRect jobDetailFrame1 = CGRectMake(0.0f, 0.0f, width, height);
    CGRect jobDetailFrame2 = CGRectMake(width, 0.0f, width, height);

    [jobDetail1.view setFrame:jobDetailFrame1];
    [jobDetail2.view setFrame:jobDetailFrame2];
    
    [jobDetail1.view setNeedsLayout];
    [jobDetail2.view setNeedsLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.job unsubscribeFromLogUpdates];
}

#pragma mark Fake IBOutlets


- (UILabel *)finishedLabel { return [self jobDetail1].finishedLabel; }
- (UILabel *)durationLabel { return [self jobDetail1].durationLabel; }
- (UILabel *)commitLabel   { return [self jobDetail1].commitLabel;   }
- (UILabel *)compareLabel  { return [self jobDetail1].compareLabel;  }
- (UILabel *)authorLabel   { return [self jobDetail2].authorLabel;   }
- (UILabel *)messageLabel  { return [self jobDetail2].messageLabel;  }
- (UILabel *)configLabel   { return [self jobDetail2].configLabel;   }
- (UILabel *)logLabel      { return [self jobDetail2].logLabel;      }

- (UITableViewController *)jobDetail1 { return (UITableViewController *)[[self childViewControllers] objectAtIndex:0]; }
- (UITableViewController *)jobDetail2 { return (UITableViewController *)[[self childViewControllers] objectAtIndex:1]; }

#pragma mark Observing the model layer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"job" isEqualToString:keyPath]) {
        id oldJob = [change valueForKey:NSKeyValueChangeOldKey];
        if ([NSNull null] != oldJob) {
            [(BWJob *)oldJob unsubscribeFromLogUpdates];
        }
        [(BWJob *)[change valueForKey:NSKeyValueChangeNewKey] subscribeToLogUpdates];
        [self configureView];
    } else if ([@"job.object.log" isEqualToString:keyPath]) {
        [self configureLogView];
    }
}

#pragma mark rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

#pragma mark toolbar

- (void)switchLargeTextArea:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self.largeTextArea setText:self.job.log];
            break;
        case 1:
            [self.largeTextArea setText:self.job.message];
            break;
        case 2:
            [self.largeTextArea setText:[self.job.config description]];
            break;
    }
}

#pragma mark Show Safari for compare_url

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [self askToViewSafariForCompare];
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
}

- (void)askToViewSafariForCompare
{
    NSString *msg = @"This will quit TravisCI and open Safari.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"View in Safari?" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View in Safari", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:self.job.compare];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark Unloading

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self removeObserver:self forKeyPath:@"job.object.log"];
    [self removeObserver:self forKeyPath:@"job"];

    [self setLargeTextArea:nil];
    [self setLargeTextAreaToggle:nil];
    [self setToolbar:nil];
    
    [self setJob:nil];
    
    [[self jobDetail1].view removeFromSuperview];
    [[self jobDetail2].view removeFromSuperview];

    for (UIViewController *child in self.childViewControllers) {
        [child removeFromParentViewController];
    }
}

@end
