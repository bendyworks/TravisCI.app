#import "Kiwi.h"
#import "BWCDRepository.h"

SPEC_BEGIN(BWRepositorySpec)

describe(@"BWCDRepository", ^{

    __block BWCDRepository *subject = nil;

    beforeEach(^{
        subject = [[BWCDRepository alloc] init];
    });
    
    describe(@"durationText", ^{
        context(@"not finished", ^{
            it(@"works", ^{
                [[theValue(YES) should] equal:theValue(YES)];
            });
        });
        context(@"finished", ^{
            xit(@"returns the formatted time difference between started and finished", ^{
                NSString *expected = @"About 1 minute";

                [subject stub:@selector(last_build_duration) andReturn:[NSNumber numberWithInt:60]];

                NSString *actual = [subject durationText];
                
                [[actual should] equal:expected];
            });
        });
        
    });

});

SPEC_END