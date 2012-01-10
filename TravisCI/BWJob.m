//
//  BWJob.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/6/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWJob.h"
#import "NSDictionary+BWTravisCI.h"

@interface BWJob()

-(NSDictionary *)config;

@end




@implementation BWJob

@dynamic log, number, result, state, status;


-(NSString *)language
{
    NSArray *languageAndVersion = [[self config] detectFromKeys:@"rvm", /* @"gemfile", @"env",*/ @"opt_release", @"php", @"node_js", nil];
    NSString *ret = [languageAndVersion componentsJoinedByString:@" "];
    return ret;
}

-(NSDictionary *)config
{
    return [self.object valueForKey:@"config"];
}

@end
