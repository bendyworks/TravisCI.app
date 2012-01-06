//
//  BWJobTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWJobTableCell : UITableViewCell
+ (NSString *)nibName;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;


@property (strong, nonatomic) IBOutlet UIImageView *buildIcon;
@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *finished_at;
@property (strong, nonatomic) IBOutlet UILabel *rvm;
@property (strong, nonatomic) IBOutlet UILabel *env;

@end
