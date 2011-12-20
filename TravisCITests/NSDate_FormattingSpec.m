#import "Kiwi.h"

#import "NSDate+Formatting.h"

SPEC_BEGIN(NSDate_FormattingSpec)

describe(@"distanceOfTimeInWords", ^{
     it(@"works despite our patching", ^{
         NSDate *now = [NSDate date];
         [[[[now dateByAddingTimeInterval:-1] distanceOfTimeInWords:now] should] equal:@"Less than 5 seconds ago"];
     });
});

describe(@"rangeOfTimeInWordsFromSeconds:", ^{
    context(@"4 seconds", ^{
        it(@"returns 'Less than 5 seconds'", ^{
            NSString *expected = @"Less than 5 seconds";
            [[[NSDate rangeOfTimeInWordsFromSeconds:4] should] equal:expected];
        });
    });
    context(@"8 seconds", ^{
        it(@"returns 'Less than 10 seconds'", ^{
            NSString *expected = @"Less than 10 seconds";
            [[[NSDate rangeOfTimeInWordsFromSeconds:8] should] equal:expected];
        });
    });
    context(@"60 seconds", ^{
        it(@"returns 'About 1 minute'", ^{
            NSString *expected = @"About 1 minute";
            [[[NSDate rangeOfTimeInWordsFromSeconds:60] should] equal:expected];
        });
    });
});

SPEC_END