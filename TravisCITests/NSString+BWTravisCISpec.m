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

    describe(@"stringBySimulatingCarriageReturn", ^{
        context(@"no carriage returns", ^{
            it(@"returns self", ^{
                NSString *subject = @"a b c\nd e f\n";

                [[[subject stringBySimulatingCarriageReturn] should] equal:subject];
            });
        });
        context(@"carriage return at beginning", ^{
            it(@"strips the carriage return", ^{
                NSString *subject = @"\ra b c\nd e f";
                NSString *expected = @"a b c\nd e f";

                [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
            });
        });
        context(@"carriage return before first newline", ^{
            it(@"removes all characters before the carriage return", ^{
                NSString *subject = @"a b c\rd e f\nm n o";
                NSString *expected = @"d e f\nm n o";
                
                [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
            });
        });
        context(@"carriage return after a newline", ^{
            it(@"removes all characters between the carriage return and previous newline", ^{
                NSString *subject = @"a b c\nd e f\rg h i";
                NSString *expected = @"a b c\ng h i";
                
                [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
            });
        });
        context(@"complicated string", ^{
            it(@"strips the correct characters", ^{
                NSString *subject = @"a b c\nd e f\r\rg h i\rj k l\nm n o\rp q r\n";
                NSString *expected = @"a b c\nj k l\np q r\n";
                
                [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
            });
        });

        //These are based off of assumptions on the travis-ci code
        context(@"travis-ci regression", ^{
            context(@"given two returns in a row", ^{
                it(@"acts as if it where a single return character", ^{
                    NSString *subject = @"a b c\nd e f\r\rg h i";
                    NSString *expected = @"a b c\ng h i";

                    [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
                });
            });
            context(@"given \\033[K\\r", ^{
                it(@"treats the set as a single return character", ^{
                    NSString *subject = @"a b c\nd e f\033[K\rg h i";
                    NSString *expected = @"a b c\ng h i";

                    [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
                });
            });
            context(@"given [2K", ^{
                it(@"ignores [2K anywhere", ^{
                    NSString *subject = @"a b c\nd e f[2K\rg h i";
                    NSString *expected = @"a b c\ng h i";
                    
                    [[[subject stringBySimulatingCarriageReturn] should] equal:expected];
                    
                });
            });
            
        });
    });

});

SPEC_END