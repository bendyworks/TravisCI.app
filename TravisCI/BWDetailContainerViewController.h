//
//  BWDetailContainerViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/12/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

@class BWRepositoryDetailViewController, BWPhoneJobDetailViewController, BWCDJob;

@interface BWDetailContainerViewController : UIViewController <UISplitViewControllerDelegate>

- (void)showJobDetailFor:(BWCDJob *)job;

@property (nonatomic, strong) UIViewController *splashViewController;
@property (nonatomic, strong) BWRepositoryDetailViewController *repositoryDetailViewController;
@property (nonatomic, strong) id jobDetailViewController;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end
