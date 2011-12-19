//
//  BWDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

@interface BWRepositoryViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Repository *repository;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
