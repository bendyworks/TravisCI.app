//
//  NSDictionary+BWTravisCI.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BWTravisCI)

- (NSDictionary *)subdictionaryUsingKeys:(NSString *)keys, ...
    NS_REQUIRES_NIL_TERMINATION;

- (NSDictionary *)subdictionaryWithoutKeys:(NSString *)keys, ...
    NS_REQUIRES_NIL_TERMINATION;

- (NSArray *)detectFromKeys:(NSString *)keys, ...
    NS_REQUIRES_NIL_TERMINATION;

@end
