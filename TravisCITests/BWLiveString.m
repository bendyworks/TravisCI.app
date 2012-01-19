//
//  BWLiveString.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/18/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWLiveString.h"
#import "NSDate+Formatting.h"

@interface BWLiveString ()

@property (nonatomic, strong, readwrite) NSString *string;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BWLiveStringUpdateFrequency updateFrequency;

- (NSTimer *)timerForNextNonlinearTrigger;
- (void)updateString;
- (void)updateStringAndResetNonlinearTimer;

@end




@implementation BWLiveString
@synthesize string = _string;
@synthesize date = _date,
    timer = _timer,
    updateFrequency = _updateFrequency;

- (id)initWithDate:(NSDate *)date
{
    return [self initWithDate:date forUpdateFrequency:BWLiveStringUpdateEverySecond];
}

- (id)initWithDate:(NSDate *)date forUpdateFrequency:(BWLiveStringUpdateFrequency)frequency
{
    self = [super init];
    if (self) {
        self.date = date;
        self.updateFrequency = frequency;

        if (BWLiveStringUpdateEverySecond == frequency) {
            self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateString) userInfo:nil repeats:YES];
        } else {
            self.timer = [self timerForNextNonlinearTrigger];
        }

        [self updateString];
    }
    return self;
}

- (NSTimer *)timerForNextNonlinearTrigger
{
    NSTimeInterval timeInterval = 1.0f; // TODO: make actually non-linear
    return [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(updateStringAndResetNonlinearTimer) userInfo:nil repeats:NO];
}

- (void)updateString
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.date];
    NSInteger timeSinceNow = [[NSNumber numberWithDouble:fabs(interval)] integerValue];

    self.string = [NSDate rangeOfTimeInWordsFromSeconds:timeSinceNow];
}

- (void)updateStringAndResetNonlinearTimer
{
    [self updateString];
    self.timer = [self timerForNextNonlinearTrigger];
}

- (void)invalidate
{
    [self.timer invalidate];
}

- (void)dealloc
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    // ARC will call [super dealloc] automatically
}

@end
