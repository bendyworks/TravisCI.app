//
//  BWPresenter.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWPresenter.h"
#import "BWColor.h"

@implementation BWPresenter
@synthesize object = _object;

+ (id)presenterWithObject:(id)obj
{
    return [[self alloc] initWithObject:obj];
}

- (id)initWithObject:(id)obj
{
    self = [super init];
    if (self != nil) {
        self.object = obj;
    }
    return self;
}

#pragma mark current status

// Subclasses should override this
- (BWStatus)currentStatus
{
    return BWStatusPending;
}



- (UIImage *)statusImage
{
    NSString *imageName = nil;
    switch ([self currentStatus]) {
        case BWStatusPending:
            imageName = @"status_yellow";
            break;
        case BWStatusFailed:
            imageName = @"status_red";
            break;
        case BWStatusPassed:
            imageName = @"status_green";
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (UIColor *)statusTextColor
{
    switch ([self currentStatus]) {
        case BWStatusPending:
            return [BWColor textColor];
        case BWStatusFailed:
            return [BWColor buildFailedColor];
        case BWStatusPassed:
            return [BWColor buildPassedColor];
    }
    return nil;
}

#pragma mark forward unknown method calls to #object

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.object methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];
    
    if ([self.object respondsToSelector:aSelector]) {
        [invocation invokeWithTarget:self.object];
    } else {
        [self doesNotRecognizeSelector:aSelector];
    }
}

@end
