//
//  BWPresenter.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWPresenter : NSObject
+ (id)presenterWithManagedObject:(NSManagedObject *)obj;
- (id)initWithManagedObject:(NSManagedObject *)obj;

@property (nonatomic, strong) NSManagedObject *object;
@end
