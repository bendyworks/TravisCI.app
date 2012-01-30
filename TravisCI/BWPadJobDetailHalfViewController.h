//
//  BWPadJobDetailHalfViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/16/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

@interface BWPadJobDetailHalfViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *finishedLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitLabel;
@property (strong, nonatomic) IBOutlet UILabel *compareLabel;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *configLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLinesLabel;

@end
