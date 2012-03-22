//
//  BWRepository.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCDRepository.h"

@interface BWCDRepository (Presenter)

+ (void)fetchRepository:(NSNumber *)remote_id;
- (void)fetchBuilds;

- (NSString *)durationText;
- (NSString *)finishedText;
- (UIImage *)statusImage;
- (UIColor *)statusTextColor;
- (NSString *)name;
- (NSString *)author;

@end
