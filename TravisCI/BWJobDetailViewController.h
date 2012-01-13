//
//  BWJobDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/11/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWJob;

@interface BWJobDetailViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) BWJob *job;

@property (nonatomic, strong) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UILabel *finishedLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitLabel;
@property (strong, nonatomic) IBOutlet UILabel *compareLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *configLabel;
@property (strong, nonatomic) IBOutlet UILabel *logTitle;
@property (strong, nonatomic) IBOutlet UILabel *logSubtitle;

- (void)askToViewSafariForCompare;

@end
