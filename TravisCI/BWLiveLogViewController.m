//
//  BWLiveLogViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWLiveLogViewController.h"

#import "BWJob.h"

@implementation BWLiveLogViewController

@synthesize textView, job;

- (void)viewWillAppear:(BOOL)animated
{
    [self.job.object addObserver:self forKeyPath:@"log" options:NSKeyValueObservingOptionNew context:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.job.object removeObserver:self forKeyPath:@"log"];
    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.textView setText:self.job.log];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

@end
