#import "Kiwi.h"
#import "NSArray+BWTravisCI.h"

SPEC_BEGIN(NSArraySpec)

describe(@"NSArray+BWTravisCI", ^{
    describe(@"mapUsingBlock", ^{

        context(@"empty array", ^{
            it(@"returns an empty array", ^{
                NSArray *subject = [NSArray array];
                NSArray *result = [subject mapUsingBlock:^id(id obj) {
                    return [NSString stringWithFormat:@"foo! %@", obj];
                }];
                [[result should] equal:[NSArray array]];
            });
        });
        
        context(@"more than zero elements", ^{
            it(@"applies the map operation", ^{
                NSArray *subject = [NSArray arrayWithObjects:@"a", @"b", nil];
                NSArray *result = [subject mapUsingBlock:^id(id obj) {
                    return [NSString stringWithFormat:@"foo! %@", obj];
                }];
                [[result should] equal:[NSArray arrayWithObjects:@"foo! a", @"foo! b", nil]];
            });
        });
    });
    
});

SPEC_END