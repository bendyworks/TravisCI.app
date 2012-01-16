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

@interface BWPadJobDetailViewController ()
- (UITableViewController *)jobDetail1;
- (UITableViewController *)jobDetail2;
@end

@implementation BWPadJobDetailViewController

@synthesize job, number;

- (void)awakeFromNib
{
    UITableViewController *jobDetail1 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail1"];
    UITableViewController *jobDetail2 = (UITableViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"JobDetail2"];
    [self addChildViewController:jobDetail1];
    [self addChildViewController:jobDetail2];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma Fake IBOutlets


- (UILabel *)finishedLabel
{
    return (UILabel *)[[self jobDetail1].tableView viewWithTag:1];
}

- (UILabel *)durationLabel
{
    return (UILabel *)[[self jobDetail1].tableView viewWithTag:2];
}

- (UILabel *)commitLabel
{
    return (UILabel *)[[self jobDetail1].tableView viewWithTag:3];
}

- (UILabel *)compareLabel
{
    return (UILabel *)[[self jobDetail1].tableView viewWithTag:4];
}

- (UILabel *)authorLabel
{
    return (UILabel *)[[self jobDetail2].tableView viewWithTag:5];
}

- (UILabel *)messageLabel
{
    return (UILabel *)[[self jobDetail2].tableView viewWithTag:6];
}

- (UILabel *)configLabel
{
    return (UILabel *)[[self jobDetail2].tableView viewWithTag:7];
}

- (UILabel *)logLabel
{
    return (UILabel *)[[self jobDetail2].tableView viewWithTag:8];
}

- (UITableViewController *)jobDetail1 { return (UITableViewController *)[[self childViewControllers] objectAtIndex:0]; }
- (UITableViewController *)jobDetail2 { return (UITableViewController *)[[self childViewControllers] objectAtIndex:1]; }


#pragma mark - View lifecycle

- (void)configureLogView
{
}

- (void)configureView
{
    
    //    [self.number setText:self.job.number];
    [self.finishedLabel setText:[self.job finishedText]];
    [self.durationLabel setText:[self.job durationText]];
    [self.commitLabel setText:self.job.commit];
    [self.compareLabel setText:self.job.compare];
    [self.authorLabel setText:self.job.author];
    [self.messageLabel setText:self.job.message];
    [self.configLabel setText:self.job.configString];
    [self configureLogView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self addObserver:self forKeyPath:@"job.object" options:NSKeyValueObservingOptionNew context:nil];
    //    [self addObserver:self forKeyPath:@"job.object.log" options:NSKeyValueObservingOptionNew context:nil];
    //    [self.job fetchDetails];
    //    [self.job subscribeToLogUpdates];
    //    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.job unsubscribeFromLogUpdates];
    [self removeObserver:self forKeyPath:@"job.object"];
    [self removeObserver:self forKeyPath:@"job.object.log"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect jobDetailFrame1 = CGRectMake(0.0f, 0.0f, 384.0f, 199.0f);
    CGRect jobDetailFrame2 = CGRectMake(384.0f, 0.0f, 384.0f, 199.0f);
    [self.view addSubview:[self jobDetail1].view];
    [self.view addSubview:[self jobDetail2].view];
    [[self jobDetail1].view setFrame:jobDetailFrame1];
    [[self jobDetail2].view setFrame:jobDetailFrame2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    for (UIViewController *child in self.childViewControllers) {
        [child removeFromParentViewController];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"job.object" isEqualToString:keyPath]) {
        [self configureView];
    } else if ([@"job.object.log" isEqualToString:keyPath]) {
        NSLog(@"job.log change observed! %@", change);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
