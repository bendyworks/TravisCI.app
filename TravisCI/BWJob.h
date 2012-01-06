//
//  BWJob.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"

@interface BWJob : BWPresenter

@property (strong, nonatomic) NSString *log;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSNumber *result;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *status;

@end
