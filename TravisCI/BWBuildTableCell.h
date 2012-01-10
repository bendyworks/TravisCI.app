//
//  BWBuildTableCell.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWTableViewCell.h"

@interface BWBuildTableCell : BWTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *buildNumber;
@property (nonatomic, strong) IBOutlet UILabel *commit;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UIImageView *statusImage;

@end
