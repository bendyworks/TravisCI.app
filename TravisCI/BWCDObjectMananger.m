//
//  BWCDObjectUpdater.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCDObjectMananger.h"
#import "RestKit/CoreData.h"
#import "BWCDRepository.h"
#import "BWJob+all.h"


@implementation BWCDObjectMananger

+ (void)updateRepositoryFromDictionary:(NSDictionary *)repositoryDictionary
{
    NSNumber *repository_id = [repositoryDictionary valueForKey:@"id"];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContext];
    NSEntityDescription *repositoryDescription = [NSEntityDescription entityForName:@"BWCDRepository" inManagedObjectContext:moc];
    NSManagedObject *repository = [objectStore findOrCreateInstanceOfEntity:repositoryDescription
                                                    withPrimaryKeyAttribute:@"remote_id"
                                                                   andValue:repository_id];

    RKObjectMapping *mapping = [manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"];
    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:repositoryDictionary
                                                                                      toObject:repository
                                                                                   withMapping:mapping];

    NSError *error = nil;
    [mappingOp performMapping:&error];

    [objectStore save];
}

+ (void)updateJobFromDictionary:(NSDictionary *)jobDictionary
{
    NSNumber *jobId = [jobDictionary valueForKey:@"id"];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContext];

    BWCDJob *job = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId inContext:moc];

    if (job == nil) { // create job
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BWCDJob" inManagedObjectContext:moc];
        BWCDJob *jobInStore = (BWCDJob *)[objectStore findOrCreateInstanceOfEntity:entityDesc
                                                           withPrimaryKeyAttribute:@"remote_id"
                                                                          andValue:jobId];
        job = jobInStore;
        [moc insertObject:job];
    }

    RKObjectMapping *mapping = [manager.mappingProvider objectMappingForKeyPath:@"BWCDJob"];
    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:jobDictionary
                                                                                      toObject:job
                                                                                   withMapping:mapping];

    NSError *error = nil;
    [mappingOp performMapping:&error];

    if (error != nil) {
        NSLog(@"Error mapping: %@", error);
    } else {
        [moc save:&error];

        if (error != nil) {
            NSLog(@"Error saving: %@", error);
        }
    }
}

+ (void)appendToJobLog:(NSDictionary *)logDictionary
{
    NSNumber *jobId = [logDictionary valueForKey:@"id"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContext];
    
    BWCDJob *job = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId inContext:moc];

    if (job == nil) { //create job
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BWCDJob" inManagedObjectContext:moc];
        BWCDJob *jobInStore = (BWCDJob *)[objectStore findOrCreateInstanceOfEntity:entityDesc
                                                        withPrimaryKeyAttribute:@"remote_id"
                                                                       andValue:jobId];
        job = jobInStore;
        [moc insertObject:job];
    }

    NSString *newLog = [job.log stringByAppendingString:[logDictionary valueForKey:@"_log"]];
    job.log = newLog;

    NSError *error = nil;
    [moc save:&error];

    if (error != nil) {
        NSLog(@"Error saving: %@", error);
    }
}

@end
