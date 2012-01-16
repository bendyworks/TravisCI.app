//
//  BWSplashScreenViewController.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWSplashScreenViewController.h"

@implementation BWSplashScreenViewController
@synthesize splashImage;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat heightOffset = -44.0f;
    CGFloat widthOffset = 0.0f;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        heightOffset = -176.0f;
        widthOffset = -32.0f;
    }
    CGRect newRect = CGRectMake(widthOffset, heightOffset, 768.0f, 1004.0f);
    [self.splashImage setFrame:newRect];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.splashImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
