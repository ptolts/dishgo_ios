//
//  UserSession.h
//  Restaurants
//
//  Created by Philip Tolton on 11/26/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject
    @property Boolean logged_in;
    @property NSString *facebookUserName;
    @property NSString *facebookId;
    + (id)sharedManager;
    - (void)openSession;
    -(UIImageView *) profilePic;
    @property (nonatomic, strong) NSString *tokenFilePath;
    - (NSString *) filePath;
@end
