//
//  BWBuild.h
//  TravisCI
//
//  Created by Bradley Grzesiak on 12/21/11.
//  Copyright (c) 2011 Bendyworks. All rights reserved.
//

#import "BWPresenter.h"

@interface BWBuild : BWPresenter

@property (nonatomic, retain) NSString *state;

@property (nonatomic, retain) NSString *author_email;
@property (nonatomic, retain) NSString *author_name;
@property (nonatomic, retain) NSString *commit;
@property (nonatomic, retain) NSString *committer_name;
@property (nonatomic, retain) NSString *compare_url;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSNumber *remote_id;

@end
