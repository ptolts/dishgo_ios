//
//  UserSession.m
//  Restaurants
//
//  Created by Philip Tolton on 11/26/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "UserSession.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation UserSession
    @synthesize logged_in;
    @synthesize facebookId;
    @synthesize facebookUserName;


    #pragma mark Singleton Methods

    + (id)sharedManager {
        static UserSession *user_session = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user_session = [[self alloc] init];
        });
        return user_session;
    }

    - (id)init {
        if (self = [super init]) {
            logged_in = NO;
        }
        return self;
    }

    - (void)dealloc {
        // Should never be called, but just here for clarity really.
    }

-(UIImage *) profilePic {
    if (FBSession.activeSession.isOpen) {
        return 
    } else {
        return [UIImage imageNamed:@"avatar.jpg"];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"Hiiiiii");
    
    switch (state) {
        case FBSessionStateOpen: {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Success"
                                      message:@"Logged in!"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     facebookUserName = user.name;
                     facebookId = user.id;
                 }
             }];
            
            logged_in = YES;
            
        }
            break;
        case FBSessionStateClosed: {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Closed"
                                      message:@"Login closed"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
        case FBSessionStateClosedLoginFailed: {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"Login failed"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default: {
            break;
        }
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         NSLog(@"result.... %@",error);
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end

