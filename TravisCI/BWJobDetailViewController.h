//
//  BWJobDetailViewController.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/11/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWJob;

@interface BWJobDetailViewController : UIViewController

@property (nonatomic, strong) BWJob *job;

@property (nonatomic, strong) IBOutlet UILabel *number;

@end
