//
//  BWJob.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"

@class BWBuild;

@interface BWJob : BWPresenter

@property (strong, nonatomic) NSString *log;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSNumber *result;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *status;
@property (readonly) BWBuild *build;

- (NSString *)language;
- (NSString *)env;
- (NSString *)durationText;
- (NSString *)finishedText;
- (NSString *)commit;
- (NSString *)compare;
- (NSString *)author;
- (NSString *)message;
- (NSString *)configString;
- (NSString *)lastLogLine;
- (NSString *)logSubtitle;

@end
