//
//  BWPresenter.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BWStatusPending,
    BWStatusPassed,
    BWStatusFailed
} BWStatus;

@interface BWPresenter : NSObject
+ (id)presenterWithObject:(id)obj;
- (id)initWithObject:(id)obj;

- (BWStatus)currentStatus;
- (UIImage *)statusImage;
- (UIColor *)statusTextColor;

@property (nonatomic, strong) id object;
@end
