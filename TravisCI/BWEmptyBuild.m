//
//  BWEmptyBuild.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/5/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWEmptyBuild.h"

@implementation BWEmptyBuild
@synthesize state, remote_id, number, author_email, author_name, commit, committer_name, compare_url, message;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.state = @"-";
        self.remote_id = [NSNumber numberWithInteger:4];
        self.number = @"-";
        self.author_email = @"-";
        self.author_name = @"-";
        self.commit = @"-";
        self.committer_name = @"-";
        self.compare_url = @"-";
        self.message = @"-";
    }
    return self;    
}

@end
