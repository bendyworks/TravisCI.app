//
//  BWTimeStampFile.h
//  TravisCI
//
//  Created by Jaymes Waters on 02/20/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWTimeStampFile : NSObject

+ (void)touchTimeStampFile;
+ (NSTimeInterval)timeIntervalFromFile;
+ (NSInteger)timeSinceAppLastOpened;
@end
