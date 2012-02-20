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

SPEC_END