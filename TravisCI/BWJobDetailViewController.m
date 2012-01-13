//
//  BWJobDetailViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/11/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWJobDetailViewController.h"
#import "BWJob.h"

@implementation BWJobDetailViewController
@synthesize finishedLabel;
@synthesize durationLabel;
@synthesize commitLabel;
@synthesize compareLabel;
@synthesize authorLabel;
@synthesize messageLabel;
@synthesize configLabel;
@synthesize logTitle;
@synthesize logSubtitle;

@synthesize job, number;

- (void)awakeFromNib
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    [self.logTitle setText:[self.job lastLogLine]];
    [self.logSubtitle setText:[self.job logSubtitle]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"job" options:NSKeyValueObservingOptionNew context:nil];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"job"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"job" isEqualToString:keyPath]) {
        [self configureView];
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
    [self setFinishedLabel:nil];
    [self setDurationLabel:nil];
    [self setCommitLabel:nil];
    [self setCompareLabel:nil];
    [self setAuthorLabel:nil];
    [self setMessageLabel:nil];
    [self setConfigLabel:nil];
    [self setLogTitle:nil];
    [self setLogSubtitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
