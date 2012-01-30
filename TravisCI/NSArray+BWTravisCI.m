//
//  NSArray+BWTravisCI.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "NSArray+BWTravisCI.h"

@implementation NSArray (BWTravisCI)

- (NSArray *)mapUsingBlock:(id (^)(id obj))block
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[self count]];
    id newObj;
    for (id obj in self) {
        newObj = block(obj);
        [ret addObject:newObj];
    }

    return [NSArray arrayWithArray:ret];
}

@end
