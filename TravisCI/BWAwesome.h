//
//  BWAwesome.h
//
//  Created by Bradley Grzesiak & Jaymes Waters on 12/13/11.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#ifndef BWAwesome_h
#define BWAwesome_h

#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define IS_IOS_50 [[[UIDevice currentDevice] systemVersion] isEqualToString:@"5.0"]
#define IS_IOS_51 [[[UIDevice currentDevice] systemVersion] isEqualToString:@"5.1"]

#endif
