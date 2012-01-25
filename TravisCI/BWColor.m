//
//  BWColor.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWColor.h"

@implementation BWColor

+ (UIColor *)textColor { return [UIColor blackColor]; }
+ (UIColor *)fadedTextColor { return [UIColor darkGrayColor]; }
+ (UIColor *)buildPassedColor { return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f]; }
+ (UIColor *)buildFailedColor { return [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f]; }
+ (UIColor *)cellTintColor { return [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f]; }

@end
