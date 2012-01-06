//
//  BWCDObjectUpdater.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWCDObjectMananger.h"
#import "RestKit/CoreData.h"

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
    NSManagedObjectContext *moc = [manager.objectStore managedObjectContext];
    NSManagedObject *repository = [manager.objectStore findOrCreateInstanceOfEntity:[NSEntityDescription entityForName:@"BWCDRepository" inManagedObjectContext:moc]
                                                            withPrimaryKeyAttribute:@"remote_id"
                                                                           andValue:repository_id];
    
    RKObjectMappingOperation *mappingOp = [RKObjectMappingOperation mappingOperationFromObject:repositoryDictionary
                                                                                      toObject:repository
                                                                                   withMapping:[manager.mappingProvider objectMappingForKeyPath:@"BWCDRepository"]];
    
    NSError *error = nil;
    [mappingOp performMapping:&error];
    
    [manager.objectStore save];
}

@end
