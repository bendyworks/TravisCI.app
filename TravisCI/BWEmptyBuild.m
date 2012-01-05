//
//  BWEmptyBuild.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Copyright (c) 2012 Bendyworks. All rights reserved.
//

#import "BWEmptyBuild.h"

@implementation BWEmptyBuild
@synthesize state, author_email, author_name, commit, committer_name, compare_url, message, remote_id;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.state = @"-";
        self.author_email = @"-";
        self.author_name = @"-";
        self.commit = @"-";
        self.committer_name = @"-";
        self.compare_url = @"-";
        self.message = @"-";
        self.remote_id = [NSNumber numberWithInteger:4];
    }
    return self;    
}

@end
