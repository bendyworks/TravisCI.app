//
//  BWPresenter.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
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
