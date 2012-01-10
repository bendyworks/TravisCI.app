//
//  BWTableViewCell.h
//  
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWTableViewCell : UITableViewCell

+ (NSString *)nibName;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

@end
