//
//  BWPresenter.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import "BWColor.h"

#ifndef BWPresenter_h
#define BWPresenter_h

typedef enum {
    BWStatusPending,
    BWStatusPassed,
    BWStatusFailed
} BWStatus;

#define PRESENT_statusImage - (UIImage *)statusImage \
{ \
    NSString *imageName = nil; \
    switch ([self currentStatus]) { \
        case BWStatusPending: \
            imageName = @"status_yellow"; \
            break; \
        case BWStatusFailed: \
            imageName = @"status_red"; \
            break; \
        case BWStatusPassed: \
            imageName = @"status_green"; \
            break; \
    } \
    return [UIImage imageNamed:imageName]; \
}

#define PRESENT_statusTextColor - (UIColor *)statusTextColor \
{ \
    switch ([self currentStatus]) { \
        case BWStatusPending: \
            return [BWColor textColor]; \
        case BWStatusFailed: \
            return [BWColor buildFailedColor]; \
        case BWStatusPassed: \
            return [BWColor buildPassedColor]; \
    } \
    return nil; \
}

#endif