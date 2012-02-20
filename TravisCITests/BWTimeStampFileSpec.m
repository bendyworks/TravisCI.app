#import "Kiwi.h"
#import "BWTimeStampFile.h"

void CleanUpCacheFile();
void CleanUpCacheFile()
{
    NSString *filePath = [BWTimeStampFile performSelector:@selector(timeStampFilePath)];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
}

SPEC_BEGIN(BWTimeStampFileSpec)

describe(@"touchTimeStampFile", ^{
    it(@"creates a timestamp file", ^{
        NSString *filePath = [BWTimeStampFile performSelector:@selector(timeStampFilePath)];
        [BWTimeStampFile touchTimeStampFile];
        [[theValue([[NSFileManager defaultManager] fileExistsAtPath:filePath]) should] beYes];
        CleanUpCacheFile();
    });
});

describe(@"timeIntervalFromFile", ^{
    it(@"should equal what is stored in the timestamp file", ^{
        [BWTimeStampFile touchTimeStampFile];
        NSString *filePath = [BWTimeStampFile performSelector:@selector(timeStampFilePath)];
        NSInteger expected = [[NSString stringWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error:nil] doubleValue];
        [[theValue([BWTimeStampFile timeIntervalFromFile]) should] equal:theValue(expected)];
        CleanUpCacheFile();
    });
});

describe(@"timeSinceAppLastOpened", ^{
    it(@"returns time difference", ^{
        NSTimeInterval testValue = 351471900;
        NSInteger expected = [[NSDate date] timeIntervalSinceReferenceDate] - testValue;
        [BWTimeStampFile stub:@selector(timeIntervalFromFile) andReturn:theValue(testValue)];
        [[theValue([BWTimeStampFile timeSinceAppLastOpened]) should] equal:theValue(expected)];
    });
});

SPEC_END