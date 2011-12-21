//
//  BWRepository.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"

@interface BWRepository : BWPresenter

- (NSString *)durationText;
- (NSString *)finishedText;

@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSString *last_build_number;
@property (nonatomic, retain) NSNumber *last_build_status;
@property (nonatomic, retain) NSNumber *last_build_duration;
@property (nonatomic, retain) NSDate *last_build_started_at;
@property (nonatomic, retain) NSDate *last_build_finished_at;

@end
