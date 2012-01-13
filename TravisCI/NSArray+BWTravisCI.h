//
//  NSArray+BWTravisCI.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/13/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BWTravisCI)

- (NSArray *)mapUsingBlock:(id (^)(id obj))block;

@end
