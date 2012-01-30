//
//  NSArray+BWTravisCI.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>

@interface NSArray (BWTravisCI)

- (NSArray *)mapUsingBlock:(id (^)(id obj))block;

@end
