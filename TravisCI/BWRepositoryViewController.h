//
//  BWDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWRepository.h"
#import "RestKit/RKManagedObjectLoader.h"

@interface BWRepositoryViewController : UIViewController <UISplitViewControllerDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) BWRepository *repository;

@property (strong, nonatomic) IBOutlet UILabel *repositoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *buildNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishedLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitLabel;
@property (strong, nonatomic) IBOutlet UILabel *compareLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *committerLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *configLabel;
@property (nonatomic, strong) IBOutlet UIImageView *statusImage;

@end
