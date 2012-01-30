//
//  BWLiveString.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/18/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>


typedef enum BWLiveStringUpdateFrequency {
    BWLiveStringUpdateEverySecond,
    BWLiveStringUpdateLessOverTime
} BWLiveStringUpdateFrequency;

@interface BWLiveString : NSObject

@property (nonatomic, strong, readonly) NSString *string;
@property (nonatomic, strong) NSDate *date;

- (id)initWithDate:(NSDate *)date;
- (id)initWithDate:(NSDate *)date forUpdateFrequency:(BWLiveStringUpdateFrequency)frequency;
- (void)invalidate;

@end
