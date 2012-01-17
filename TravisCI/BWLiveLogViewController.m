//
//  BWLiveLogViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/17/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWLiveLogViewController.h"

#import "BWJob.h"

@implementation BWLiveLogViewController

@synthesize textView, job;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.job addObserver:self forKeyPath:@"object.log" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.job removeObserver:self forKeyPath:@"object.log"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.textView setText:self.job.log];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { return YES; }

@end
