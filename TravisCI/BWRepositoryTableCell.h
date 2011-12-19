//
//  BWRepositoryTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWRepositoryTableCell : UITableViewCell
+ (NSString *)nibName;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

@property (nonatomic, strong) IBOutlet UILabel *slug;
@property (nonatomic, strong) IBOutlet UILabel *buildNumber;
@property (nonatomic, strong) IBOutlet UIImageView *statusImage;

@end
