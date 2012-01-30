//
//  BWRepositoryTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWTableViewCell.h"

@interface BWRepositoryTableCell : BWTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *slug;
@property (nonatomic, strong) IBOutlet UILabel *buildNumber;
@property (nonatomic, strong) IBOutlet UILabel *duration;
@property (nonatomic, strong) IBOutlet UILabel *finished;
@property (nonatomic, strong) IBOutlet UIImageView *statusImage;

@end
