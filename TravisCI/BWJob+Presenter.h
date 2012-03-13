//
//  BWJob.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCDJob.h"
#import "CoreData.h"

@class BWBuild;

@interface BWCDJob (BWPresenter)

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
- (UIImage *)statusImage;
- (UIColor *)statusTextColor;


- (void)fetchDetails;
- (void)fetchDetailsIfNeeded;
- (void)subscribeToLogUpdates;
- (void)unsubscribeFromLogUpdates;

- (NSString *)formattedNumberOfLinesInLog;
@end
