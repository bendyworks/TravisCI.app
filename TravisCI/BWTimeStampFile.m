//
//  BWTimeStampFile.m
//  TravisCI
//
//  Created by Jaymes Waters on 02/20/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWTimeStampFile.h"
#import "BWAppDelegate.h"

#define TRAVIS_CI_TIMESTAMP_FILE_NAME @"lastOpened"

@interface BWTimeStampFile()
+ (NSString *)timeStampFilePath;
@end

@implementation BWTimeStampFile


+ (NSString *)timeStampFilePath
{
    NSURL *cacheDir = [(BWAppDelegate *)[[UIApplication sharedApplication] delegate] applicationCacheDirectory];
    return [[cacheDir URLByAppendingPathComponent:TRAVIS_CI_TIMESTAMP_FILE_NAME] path];
}

+ (void)touchTimeStampFile
{
    NSNumber *timeStampNumber = [NSNumber numberWithInt:[[NSDate date] timeIntervalSinceReferenceDate]];
    NSData *timeStamp = [[timeStampNumber stringValue] dataUsingEncoding:NSUnicodeStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:[self timeStampFilePath] contents:timeStamp attributes:nil];
}

+ (NSTimeInterval)timeIntervalFromFile
{
    NSTimeInterval appOpenedLast = [[NSDate date] timeIntervalSinceReferenceDate];
    NSError *error = nil;
    NSString *timeStampFileString = [NSString stringWithContentsOfFile:[self timeStampFilePath] encoding:NSUnicodeStringEncoding error:&error];

    if (timeStampFileString) {
        appOpenedLast = [timeStampFileString doubleValue];
    } else {
        [self touchTimeStampFile];
    }

    return floor(appOpenedLast);
}

+ (NSInteger)secondsSinceAppLastClosed
{
    return [[NSDate date] timeIntervalSinceReferenceDate] - [self timeIntervalFromFile];
}

@end
