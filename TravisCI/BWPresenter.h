//
//  BWPresenter.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWPresenter : NSObject
+ (id)presenterWithObject:(id)obj;
- (id)initWithObject:(id)obj;

@property (nonatomic, strong) id object;
@end
