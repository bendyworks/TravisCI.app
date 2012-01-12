//
//  BWDetailContainerViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWRepositoryDetailViewController;

@interface BWDetailContainerViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) UIViewController *splashViewController;
@property (nonatomic, strong) BWRepositoryDetailViewController *repositoryDetailViewController;

@end
