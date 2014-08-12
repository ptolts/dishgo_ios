//
//  UserSession.h
//  Restaurants
//
//  Created by Philip Tolton on 11/26/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "SetRating.h"

@interface UserSession : NSObject
    @property User *main_user;
    @property Boolean logged_in;
    @property NSString *facebookUserName;
    @property NSString *lat;
    @property NSString *lon;
    @property NSString *facebookId;
    @property NSString *facebookToken;
    @property NSString *foodcloudToken;
    @property SetRating *current_restaurant_ratings;
    -(User *) fetchUser;
    -(void) fetch_ratings:(NSString *) restaurant_id;
    + (id)sharedManager;
    -(BOOL) hasAddress;
    - (void)openSession:(void (^)(bool, NSString *))block;
    - (void)logout;
    - (void) completeLogin;
    -(void) signUp:(NSString *)email password: (NSString *) password block:(void (^)(bool, NSString *))block;
    -(void) signIn:(NSString *)email password: (NSString *) password block:(void (^)(bool, NSString *))block;
    -(void) setAddress:(NSMutableDictionary *) dict block:(void (^)(bool, NSString *))block;
    -(UIImageView *) profilePic:(bool)shopping color:(UIColor *)color rect:(CGRect)rect;
    @property (nonatomic, strong) NSString *tokenFilePath;
//    - (NSString *) filePath;
@end
