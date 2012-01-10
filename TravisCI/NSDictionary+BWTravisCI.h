//
//  NSDictionary+BWTravisCI.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BWTravisCI)

- (NSDictionary *)subdictionaryUsingKeys:(NSString *)keys, ...
    NS_REQUIRES_NIL_TERMINATION;

- (NSArray *)detectFromKeys:(NSString *)keys, ...
    NS_REQUIRES_NIL_TERMINATION;

@end
