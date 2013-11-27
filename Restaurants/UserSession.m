//
//  UserSession.m
//  Restaurants
//
//  Created by Philip Tolton on 11/26/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "UserSession.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK/FBAccessTokenData.h>

static NSString* kFilename = @"TokenInfo.plist";

@implementation UserSession
@synthesize logged_in;
@synthesize facebookId;
@synthesize facebookUserName;

//- (void)cacheFBAccessTokenData:(FBAccessTokenData *)accessToken {
//    NSDictionary *tokenInformation = [accessToken dictionary];
//    [self writeData:tokenInformation];
//}

- (FBAccessTokenData *)fetchFBAccessTokenData
{
    NSDictionary *tokenInformation = [self readData];
    if (nil == tokenInformation) {
        return nil;
    } else {
        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
    }
}

- (void)clearToken
{
    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
}

- (NSString *) filePath {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void) writeData:(NSDictionary *) data {
    NSLog(@"File = %@ and Data = %@", self.tokenFilePath, data);
    BOOL success = [data writeToFile:self.tokenFilePath atomically:YES];
    if (!success) {
        NSLog(@"Error writing to file");
    }
}

- (NSDictionary *) readData {
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:self.tokenFilePath];
    NSLog(@"File = %@ and data = %@", self.tokenFilePath, data);
    return data;
}

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
        self.tokenFilePath = [self filePath];
        if([[self readData] objectForKey:@"facebook_token"]){
            if ([FBSession activeSession]){
                [[FBSession activeSession] closeAndClearTokenInformation];
            }
            FBSession *session = [[FBSession alloc] init];
            [FBSession setActiveSession:session];

            NSLog(@"STATE: %u",session.state);
            if(session.state == FBSessionStateCreated){
                NSDictionary *dic = [self readData];
                NSString *tok = [dic objectForKey:@"facebook_token"];
                NSArray *per = [dic objectForKey:@"facebook_permissions"];
                FBSessionLoginType lt = (FBSessionLoginType) [dic objectForKey:@"facebook_login_type"];
                FBAccessTokenData *access_token = [FBAccessTokenData createTokenFromString:tok permissions:per expirationDate:nil loginType:lt refreshDate:nil];
                [session openFromAccessTokenData:access_token completionHandler:
                 ^(FBSession *session, FBSessionState state, NSError *error) {
                     NSLog(@"result.... %@",error);
                     [self sessionStateChanged:session state:state error:error];
                 }];
            } else {
                NSError *error;
                [self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:error];
            }
        }
    }
    return self;
}

- (void) updateFacebookCred {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             facebookUserName = user.name;
             facebookId = user.id;
         }
     }];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(UIImageView *) profilePic {
    if (FBSession.activeSession.isOpen) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 50, 50)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        __weak typeof(imageView) weakImage = imageView;
        [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",facebookId]]
                           placeholderImage:[UIImage imageNamed:@"Default.png"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (image && cacheType == SDImageCacheTypeNone)
                                      {
                                          weakImage.alpha = 0.0;
                                          [UIView animateWithDuration:1.0
                                                           animations:^{
                                                               weakImage.alpha = 1.0;
                                                           }];
                                      }
                                  }];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        return imageView;
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 50, 50)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        return imageView;
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
            
            
            [self writeData:[[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%@",[session accessTokenData].accessToken],@"facebook_token",
                             [session permissions],@"facebook_permissions",
                             [NSString stringWithFormat:@"%u",[session accessTokenData].loginType],@"facebook_login_type",
             
             nil]];
            
            [self updateFacebookCred];
            
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

