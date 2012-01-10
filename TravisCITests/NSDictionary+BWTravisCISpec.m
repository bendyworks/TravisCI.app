//
//  NSDictionary+BWTravisCISpec.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "Kiwi.h"
#import "NSDictionary+BWTravisCI.h"

SPEC_BEGIN(NSDictionarySpec)

describe(@"NSDictionary+BWTravisCI", ^{
    
    __block NSDictionary *subject = nil;
    
    beforeEach(^{
        subject = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"a", @"2", @"b", @"3", @"c", nil];
    });
    
    describe(@"subdictionaryUsingKeys", ^{
        context(@"matching nothing", ^{
            it(@"returns an empty dictionary", ^{
                NSDictionary *result = [subject subdictionaryUsingKeys:@"foo", nil];
                [[theValue(result.count) should] equal:theValue(0)];
            });
        });
        context(@"matching something", ^{
            it(@"returns a subset dictionary", ^{
                NSDictionary *result = [subject subdictionaryUsingKeys:@"a", nil];
                [[result should] equal:[NSDictionary dictionaryWithObject:@"1" forKey:@"a"]];
            });
        });
        context(@"matching ALL THE THINGS", ^{
            it(@"returns a copy of the dictionary", ^{
                NSDictionary *result = [subject subdictionaryUsingKeys:@"a", @"b", @"c", nil];
                [[result should] equal:[subject copy]];
            });
        });
        
    });
    
});

SPEC_END