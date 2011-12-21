//
//  BWPresenter.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"

@implementation BWPresenter
@synthesize object = _object;

+ (id)presenterWithManagedObject:(NSManagedObject *)obj
{
    return [[self alloc] initWithManagedObject:obj];
}

- (id)initWithManagedObject:(NSManagedObject *)obj
{
    self = [super init];
    if (self != nil) {
        self.object = obj;
    }
    return self;
}


@end
