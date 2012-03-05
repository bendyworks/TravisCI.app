//
//  BWJobDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/11/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

@class BWCDJob;

@interface BWPhoneJobDetailViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) BWCDJob *job;

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
