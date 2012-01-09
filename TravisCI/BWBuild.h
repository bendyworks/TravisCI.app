//
//  BWBuild.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"
#import "RestKit/RKObjectLoader.h"

@interface BWBuild : BWPresenter <RKObjectLoaderDelegate>

- (void)fetchJobs;

@property (nonatomic, strong) NSNumber *remote_id;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *author_email;
@property (nonatomic, strong) NSString *author_name;
@property (nonatomic, strong) NSString *commit;
@property (nonatomic, strong) NSString *committer_name;
@property (nonatomic, strong) NSString *compare_url;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *repository_id;

@end
