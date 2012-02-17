//
//  BWTableViewCell.h
//
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <UIKit/UIKit.h>

@interface BWTableViewCell : UITableViewCell

+ (NSString *)nibName;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (UINib *)nib;

@end
