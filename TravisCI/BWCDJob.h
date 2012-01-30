//
//  BWCDJob.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BWCDBuild;

@interface BWCDJob : NSManagedObject

@property (nonatomic, retain) NSDictionary *config;
@property (nonatomic, retain) NSDate * finished_at;
@property (nonatomic, retain) NSString * log;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSNumber * repository_id;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSDate * started_at;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) BWCDBuild *build;

@end
