//
//  NSString+BWTravisCI.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "NSString+BWTravisCI.h"

@implementation NSString (BWTravisCI)

- (NSString *)lastLine
{
    NSRange range;
    range.location = 0;
    range.length = [self length];
    
    NSStringEnumerationOptions enumOptions = NSStringEnumerationByLines | NSStringEnumerationReverse;
    
    __block NSString *ret = nil;

    [self enumerateSubstringsInRange:range options:enumOptions usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        ret = substring;
        *stop = YES;
    }];

    return ret;
}

@end
