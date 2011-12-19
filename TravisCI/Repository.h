//
//  Repository.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/19/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repository : NSManagedObject

@property (nonatomic, retain) NSDate * last_build_started_at;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * remote_description;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSNumber * last_build_id;
@property (nonatomic, retain) NSString * last_build_number;
@property (nonatomic, retain) NSDate * last_build_finished_at;
@property (nonatomic, retain) NSNumber * last_build_status;
@property (nonatomic, retain) NSString * last_build_language;
@property (nonatomic, retain) NSNumber * last_build_duration;
@property (nonatomic, retain) NSNumber * last_build_result;

@end
