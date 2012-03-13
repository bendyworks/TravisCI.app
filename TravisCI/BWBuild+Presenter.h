//
//  BWBuild.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCDBuild.h"
#import "RKObjectLoader.h"

@interface BWCDBuild (Presenter)

- (UIImage *)statusImage;
- (UIColor *)statusTextColor;

- (void)fetchJobs;

@property (readonly) NSString *formattedNumber;

@end
