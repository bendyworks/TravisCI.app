//
//  BWColor.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWColor : NSObject

+ (UIColor *)textColor;
+ (UIColor *)fadedTextColor;
+ (UIColor *)buildPassedColor;
+ (UIColor *)buildFailedColor;

@end
