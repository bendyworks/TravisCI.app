//
//  BWRepository.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/20/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWRepository : NSObject

+ (BWRepository *)repositoryWithManagedObject:(NSManagedObject *)obj;
- (id)initWithManagedObject:(NSManagedObject *)obj;

- (NSString *)timingText;

- (NSString *)slug;
- (NSString *)last_build_number;
- (NSNumber *)last_build_status;

@property (strong) id object;

@end
