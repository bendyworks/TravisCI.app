//
//  BWEmptyBuild.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWEmptyBuild : NSObject

@property (nonatomic, strong) NSNumber *remote_id;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *author_email;
@property (nonatomic, strong) NSString *author_name;
@property (nonatomic, strong) NSString *commit;
@property (nonatomic, strong) NSString *committer_name;
@property (nonatomic, strong) NSString *compare_url;
@property (nonatomic, strong) NSString *message;
@end
