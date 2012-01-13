#import "Kiwi.h"
#import "NSString+BWTravisCI.h"

SPEC_BEGIN(NSStringSpec)

describe(@"NSString+BWTravisCI", ^{
    describe(@"lastLine", ^{

        context(@"string with no newlines", ^{
            it(@"returns a copy", ^{
                NSString *subject = @"a b c";
                NSString *result = [subject lastLine];
                [[result should] equal:subject];
            });
        });

        context(@"string with one newline", ^{
            it(@"returns the string after the last newline", ^{
                NSString *subject = @"a b c\nd e f";
                NSString *result = [subject lastLine];
                [[result should] equal:@"d e f"];
            });
        });

        context(@"string with many newlines", ^{
            it(@"returns the string after the last newline", ^{
                NSString *subject = @"a b c\nd e f\ng h i\nx y z";
                NSString *result = [subject lastLine];
                [[result should] equal:@"x y z"];
            });
        });

    });
});

SPEC_END