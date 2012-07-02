//
//  BWCDObjectUpdater.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWCDObjectMananger.h"
#import <CoreData.h>
#import "BWCDRepository.h"
#import "BWJob+all.h"


@implementation BWCDObjectMananger

+ (void)updateRepositoryFromDictionary:(NSDictionary *)repositoryDictionary
{
    NSNumber *repository_id = [repositoryDictionary valueForKey:@"id"];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContextForCurrentThread];

    BWCDRepository *repository = [BWCDRepository findFirstByAttribute:@"remote_id" withValue:repository_id inContext:moc];

    if (repository == nil) {
        // TODO: re-insert "findOrCreate" into NSManagedObject+ActiveRecord
        repository = [BWCDRepository findFirstByAttribute:@"remote_id" withValue:repository_id];
        if ( ! repository ) {
            repository = [BWCDRepository createEntity];
            repository.remote_id = repository_id;
        }
        [moc insertObject:repository];
    }

    RKObjectMappingDefinition *mapping = [manager.mappingProvider mappingForKeyPath:@"BWCDRepository"];
    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:repositoryDictionary
                                                                                      toObject:repository
                                                                                   withMapping:mapping];

    NSError *error = nil;
    [mappingOp performMapping:&error];
    if (error != nil) {
        NSLog(@"Error mapping: %@", error);
    } else {
        [moc save:&error];
        if (error != nil) {
            NSLog(@"Error mapping: %@", error);
        }
    }
}

+ (void)updateJobFromDictionary:(NSDictionary *)jobDictionary
{
    NSNumber *jobId = [jobDictionary valueForKey:@"id"];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContextForCurrentThread];

    BWCDJob *job = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId inContext:moc];

    if (job == nil) { // create job
        BWCDJob *jobInStore = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId];
        if ( ! jobInStore ) {
            jobInStore = [BWCDJob createEntity];
            jobInStore.remote_id = jobId;
        }
        job = jobInStore;
        [moc insertObject:job];
    }

    RKObjectMappingDefinition *mapping = [manager.mappingProvider mappingForKeyPath:@"BWCDJob"];
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
    NSManagedObjectContext *moc = [objectStore managedObjectContextForCurrentThread];
    
    BWCDJob *job = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId inContext:moc];

    if (job == nil) { //create job
        BWCDJob *jobInStore = [BWCDJob findFirstByAttribute:@"remote_id" withValue:jobId];
        if ( ! jobInStore ) {
            jobInStore = [BWCDJob createEntity];
            jobInStore.remote_id = jobId;
        }
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
