//
//  NSString+BWTravisCI.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
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

- (NSUInteger)numberOfNewlines
{
    NSUInteger ret = 0;
    const char *utf8string = [self UTF8String];
    for (NSInteger i = 0; utf8string[i] != 0; i++) {
        if (utf8string[i] == '\n') {
            ret++;
        }
    }
    return ret;
}

- (NSString *)stringBySimulatingCarriageReturn
{
    NSString *ret = self;
    NSString *matcher = nil;
    NSStringCompareOptions compareOptions = NSRegularExpressionSearch;
    NSRange wholeRange = {0, 0};

    matcher = @"\r\r";
//    wholeRange = NSMakeRange(0, [ret length]);
    ret = [ret stringByReplacingOccurrencesOfString:matcher withString:@"\r"];

    matcher = @"\033[K";
//    wholeRange = NSMakeRange(0, [ret length]);
    ret = [ret stringByReplacingOccurrencesOfString:matcher withString:@""];

    matcher = @"(?:\[2K|\033\(B)";
    wholeRange = NSMakeRange(0, [ret length]);
    ret = [ret stringByReplacingOccurrencesOfString:matcher withString:@"" options:compareOptions range:wholeRange];

    NSMutableString *history = [NSMutableString string];
    NSUInteger cursor = 0;
    NSMutableString *currentLine = [NSMutableString string];

    const char *utf8string = [ret UTF8String];
    for (NSInteger i = 0; utf8string[i] != 0; i++) {
        char chr = utf8string[i];
        if (chr == '\n') {
            // flush currentLine to history
            [history appendString:[NSString stringWithFormat:@"%@\n", currentLine]];
            [currentLine deleteCharactersInRange:NSMakeRange(0, [currentLine length])];
            cursor = 0;
        } else if (chr == '\r') {
            cursor = 0;
        } else {
            if (cursor == 0 && [currentLine length] > 0) {
                [currentLine deleteCharactersInRange:NSMakeRange(0, [currentLine length])];
            }
            [currentLine appendFormat:@"%c", chr];
            cursor++;
        }
    }

    [history appendString:currentLine];

    return history;
}

@end
