//
//  BWPadJobDetailHalfViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/16/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWPadJobDetailHalfViewController.h"
#import "BWPadJobDetailViewController.h"

@interface BWPadJobDetailHalfViewController()
- (BOOL)isJobDetail1;
@end

@implementation BWPadJobDetailHalfViewController
@synthesize finishedLabel;
@synthesize durationLabel;
@synthesize commitLabel;
@synthesize compareLabel;
@synthesize authorLabel;
@synthesize messageLabel;
@synthesize configLabel;
@synthesize logLinesLabel;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)isJobDetail1
{
    return finishedLabel != nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BWPadJobDetailViewController *parent = (BWPadJobDetailViewController *)self.parentViewController;
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        if (![self isJobDetail1] && indexPath.row == 0) {
            [parent askToViewSafariForCompare];
        }
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"table width: %f", self.tableView.frame.size.width);
}

- (void)viewDidUnload {
    [self setFinishedLabel:nil];
    [self setDurationLabel:nil];
    [self setCommitLabel:nil];
    [self setCompareLabel:nil];
    [self setAuthorLabel:nil];
    [self setMessageLabel:nil];
    [self setConfigLabel:nil];
    [self setLogLinesLabel:nil];
    [super viewDidUnload];
}
@end
