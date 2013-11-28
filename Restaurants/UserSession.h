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
    @property NSString *facebookToken;
    @property NSString *foodcloudToken;
    + (id)sharedManager;
    - (void)openSession;
    - (void)logout;
    -(void) signUp:(NSString *)email password: (NSString *) password block:(void (^)(bool))block;
    -(void) signIn:(NSString *)email password: (NSString *) password block:(void (^)(bool))block;
    -(UIImageView *) profilePic;
    @property (nonatomic, strong) NSString *tokenFilePath;
    - (NSString *) filePath;
@end
