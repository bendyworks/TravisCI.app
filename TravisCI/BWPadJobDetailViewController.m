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
- (void)layoutPortrait;
- (void)layoutLandscape;
- (void)configureView;
- (void)configureLogView;
- (void)configureViewWithoutLog;
- (void)doLayout;
- (void)doLayoutForOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation BWPadJobDetailViewController
@synthesize toolbar;
@synthesize largeTextArea;
@synthesize largeTextAreaToggle;

@synthesize job, number;

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableViewController *jobDetail1 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail1"];
    UITableViewController *jobDetail2 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail2"];
    [self addChildViewController:jobDetail1];
    [self addChildViewController:jobDetail2];
    [self doLayout];
    jobDetail1.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    jobDetail2.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:jobDetail1.view];
    [self.view addSubview:jobDetail2.view];
    NSLog(@"initial autoresizing masks: %x %x", jobDetail1.view.autoresizingMask, jobDetail2.view.autoresizingMask);

    [self.largeTextAreaToggle addTarget:self
                                 action:@selector(switchLargeTextArea:)
                       forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.jobDetail2.view setNeedsLayout];
    
    [self addObserver:self forKeyPath:@"job.object" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"job.object.log" options:NSKeyValueObservingOptionNew context:nil];

    [self.job fetchDetails];
    [self.job subscribeToLogUpdates];

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

//    [[self jobDetail1].view setNeedsLayout];
//    [[self jobDetail2].view setNeedsLayout];
    
}

- (void)configureLogView
{
    [self.largeTextArea setText:job.log];
}

- (void)doLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    [self layoutPortrait];

//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//        [self layoutPortrait];
//    } else {
//        [self layoutLandscape];
//    }
    
    [[self jobDetail1].view setNeedsLayout];
    [[self jobDetail2].view setNeedsLayout];
}

- (void)doLayout
{
    [self doLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)layoutPortrait
{
    CGFloat width = (768.0f) / 2.0f;
    NSLog(@"width: %f", width);
    CGRect jobDetailFrame1 = CGRectMake(0.0f, 0.0f, width, 154.0f);
    CGRect jobDetailFrame2 = CGRectMake(width, 0.0f, width, 154.0f);
    [[self jobDetail1].view setFrame:jobDetailFrame1];
    [[self jobDetail2].view setFrame:jobDetailFrame2];
}

- (void)layoutLandscape
{
    CGFloat width = (1024.0f - 320.0f) / 2.0f;
    NSLog(@"width: %f", width);
    CGRect jobDetailFrame1 = CGRectMake(0.0f, 0.0f, width, 154.0f);
    CGRect jobDetailFrame2 = CGRectMake(width, 0.0f, width, 154.0f);
    [[self jobDetail1].view setFrame:jobDetailFrame1];
    [[self jobDetail2].view setFrame:jobDetailFrame2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.job unsubscribeFromLogUpdates];

    [self removeObserver:self forKeyPath:@"job.object"];
    [self removeObserver:self forKeyPath:@"job.object.log"];
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

#pragma mark rotation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotate tableview1 frame: %@", NSStringFromCGRect(self.jobDetail1.view.frame));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"will rotate tableview1 frame: %@", NSStringFromCGRect(self.jobDetail1.view.frame));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

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



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"job.object" isEqualToString:keyPath]) {
        [self configureViewWithoutLog];
    } else if ([@"job.object.log" isEqualToString:keyPath]) {
        [self configureLogView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = [segue destinationViewController];
    if ([@"message" isEqualToString:segue.identifier]) {
        UITextView *textView = (UITextView *)vc.view;
        [textView setText:self.job.message];
    } else if ([@"compare" isEqualToString:segue.identifier]) {
        UIWebView *webView = (UIWebView *)vc.view;
        NSURL *url = [NSURL URLWithString:self.job.compare];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    } else if ([@"config" isEqualToString:segue.identifier]) {
        ((BWEnumerableTableViewController *)vc).data = self.job.config;
    } else if ([@"log" isEqualToString:segue.identifier]) {
        UITextView *textView = (UITextView *)vc.view;
        [textView setText:self.job.log];
    }
}

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

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setLargeTextArea:nil];
    [self setLargeTextAreaToggle:nil];
    [self setToolbar:nil];
    
//    [[self jobDetail1].view removeFromSuperview];
//    [[self jobDetail2].view removeFromSuperview];

//    for (UIViewController *child in self.childViewControllers) {
//        [child removeFromParentViewController];
//    }
}

@end
