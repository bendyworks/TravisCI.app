//
//  BWBuildTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWBuildTableCell : UITableViewCell

+ (NSString *)nibName;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;


@property (nonatomic, strong) IBOutlet UILabel *buildNumber;
@property (nonatomic, strong) IBOutlet UILabel *commit;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UIImageView *statusImage;

@end
