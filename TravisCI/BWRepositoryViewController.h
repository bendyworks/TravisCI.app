//
//  BWDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWRepository.h"
#import "BWBuild.h"
#import "RestKit/RKManagedObjectLoader.h"
#import "BWJobTableViewController.h"

@interface BWRepositoryViewController : UIViewController <UISplitViewControllerDelegate, RKObjectLoaderDelegate>

- (void)configureViewAndSetRepository:(BWRepository *)newRepository;

@property (strong, nonatomic) BWRepository *repository;
@property (strong, nonatomic) BWBuild *build;

@property (strong, nonatomic) BWJobTableViewController *jobTable;

@property (strong, nonatomic) IBOutlet UILabel *repositoryName;
@property (strong, nonatomic) IBOutlet UILabel *buildNumber;
@property (strong, nonatomic) IBOutlet UILabel *finished;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *commit;
@property (strong, nonatomic) IBOutlet UILabel *compare;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *committer;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *config;
@property (nonatomic, strong) IBOutlet UIImageView *statusIcon;

@end
