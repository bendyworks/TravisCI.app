//
//  BWJob.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"
#import "RestKit/CoreData.h"

@class BWBuild;

@interface BWJob : BWPresenter <RKObjectLoaderDelegate>

@property (strong, nonatomic) NSString *log;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSNumber *result;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *remote_id;
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
- (NSDictionary *)config;

- (void)fetchDetails;
- (void)subscribeToLogUpdates;
- (void)unsubscribeFromLogUpdates;

@end
