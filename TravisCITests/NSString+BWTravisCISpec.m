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
    
    describe(@"numberOfNewlines", ^{
        context(@"with no newlines", ^{
            it(@"returns 0", ^{
                NSString *subject = @"a b c";
                NSInteger result = [subject numberOfNewlines];
                [[theValue(result) should] equal:theValue(0)];
            });
        });
        
        context(@"with 1 newline", ^{
            it(@"returns 1", ^{
                NSString *subject = @"a b c\nd e f";
                NSInteger result = [subject numberOfNewlines];
                [[theValue(result) should] equal:theValue(1)];
            });
        });
        
        context(@"with 1 newline in the middle and 1 at the end", ^{
            it(@"returns 2", ^{
                NSString *subject = @"a b c\nd e f\n";
                NSInteger result = [subject numberOfNewlines];
                [[theValue(result) should] equal:theValue(2)];
            });
        });
    });
});

SPEC_END