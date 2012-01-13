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
    
    describe(@"detectFromKeys", ^{
        context(@"matching nothing", ^{
            it(@"returns nil", ^{
                NSArray *result = [subject detectFromKeys:@"foo", nil];
                [result shouldBeNil];
            });
        });
        context(@"matching something", ^{
            it(@"returns an array of [key, value]", ^{
                NSArray *result = [subject detectFromKeys:@"a", nil];
                [[result should] equal:[NSArray arrayWithObjects:@"a", @"1", nil]];
            });
        });
        context(@"matches more than one thing", ^{
            it(@"returns the first match as an array of [key, value]", ^{
                NSArray *result = [subject detectFromKeys:@"b", @"a", @"c", nil];
                [[result should] equal:[NSArray arrayWithObjects:@"b", @"2", nil]];
            });
        });
        
    });
    
    
    describe(@"subdictionaryWithoutKeys", ^{
        context(@"matching nothing", ^{
            it(@"returns a copy", ^{
                NSDictionary *result = [subject subdictionaryWithoutKeys:@"foo", nil];
                [[result should] equal:[subject copy]];
            });
        });
        
        context(@"matching something", ^{
            it(@"returns a subset dictionary", ^{
                NSDictionary *result = [subject subdictionaryWithoutKeys:@"b", nil];
                [[result should] equal:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"a", @"3", @"c", nil]];
            });
        });

        context(@"matching everything", ^{
            it(@"returns an empty dictionary", ^{
                NSDictionary *result = [subject subdictionaryWithoutKeys:@"a", @"b", @"c", nil];
                [[result should] equal:[NSDictionary dictionary]];
            });
        });
    });
});

SPEC_END