//
//  BWDetailContainerViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWRepositoryDetailViewController, BWJobDetailViewController, BWJob;

@interface BWDetailContainerViewController : UIViewController <UISplitViewControllerDelegate>

- (void)showJobDetailFor:(BWJob *)job;

@property (nonatomic, strong) UIViewController *splashViewController;
@property (nonatomic, strong) BWRepositoryDetailViewController *repositoryDetailViewController;
@property (nonatomic, strong) BWJobDetailViewController *jobDetailViewController;

@end
