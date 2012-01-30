//
//  BWJobTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

#import "BWTableViewCell.h"

@interface BWJobTableCell : BWTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *buildIcon;
@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *finished_at;
@property (strong, nonatomic) IBOutlet UILabel *language;
@property (strong, nonatomic) IBOutlet UILabel *env;

@end
