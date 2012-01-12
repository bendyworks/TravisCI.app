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

- (void)awakeFromNib
{
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
    [self setSplashImage:nil];
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
