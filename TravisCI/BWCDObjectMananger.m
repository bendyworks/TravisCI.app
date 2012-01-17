//
//  BWCDObjectUpdater.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWCDObjectMananger.h"
#import "RestKit/CoreData.h"
#import "BWCDRepository.h"

@implementation BWCDObjectMananger


+ (NSManagedObject *)buildWithID:(NSNumber *)build_id
{
    NSManagedObjectContext *moc = [[RKObjectManager sharedManager].objectStore managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BWCDBuild"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remote_id = %@", build_id];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetched_results = [moc executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"buildWithID: %@ threw error: \n %@", build_id,error);
    }

    return [fetched_results lastObject];
}

+ (void)updateRepositoryFromDictionary:(NSDictionary *)repositoryDictionary
{
    NSNumber *repository_id = [repositoryDictionary valueForKey:@"id"];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKManagedObjectStore *objectStore = manager.objectStore;
    NSManagedObjectContext *moc = [objectStore managedObjectContext];
    NSManagedObject *repository = [objectStore findOrCreateInstanceOfEntity:[NSEntityDescription entityForName:@"BWCDRepository" inManagedObjectContext:moc]
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
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BWCDJob" inManagedObjectContext:moc];
    NSManagedObject *job = [objectStore findOrCreateInstanceOfEntity:entityDesc
                                             withPrimaryKeyAttribute:@"remote_id"
                                                            andValue:jobId];
    
    RKObjectMapping *mapping = [manager.mappingProvider objectMappingForKeyPath:@"BWCDJob"];
    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:jobDictionary
                                                                                      toObject:job
                                                                                   withMapping:mapping];
    
    NSError *error = nil;
    [mappingOp performMapping:&error];
    
    [objectStore save];
}

@end
