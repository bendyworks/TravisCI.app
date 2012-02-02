//
//  BWColor.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>

@interface BWColor : NSObject

+ (UIColor *)textColor;
+ (UIColor *)fadedTextColor;
+ (UIColor *)buildPassedColor;
+ (UIColor *)buildFailedColor;
+ (UIColor *)cellTintColor;

@end
