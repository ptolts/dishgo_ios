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
#import <RestKit/RestKit.h>
#import "User.h"

static NSString* kFilename = @"TokenInfo.plist";

@implementation UserSession
@synthesize logged_in;
@synthesize facebookId;
@synthesize facebookUserName;
@synthesize facebookToken;
@synthesize foodcloudToken;

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

- (NSMutableDictionary *) readData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.tokenFilePath];
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
                     [self sessionStateChanged:session state:state error:error block:^(bool obj, NSString *result) {
                         // Does nothing, but conforms to the function.
                     }];
                 }];
            }
        } else if ([[self readData] objectForKey:@"foodcloud_token"]){
            NSDictionary *dic = [self readData];
            NSString *tok = [dic objectForKey:@"foodcloud_token"];
            foodcloudToken = tok;
            logged_in = YES;
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

-(UIImageView *) profilePic:(bool)shopping color:(UIColor *)color rect:(CGRect) rect{
    if (FBSession.activeSession.isOpen) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        __weak typeof(imageView) weakImage = imageView;
        [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",facebookId]]
                           placeholderImage:[UIImage imageNamed:@"avatar_logged_black.png"]
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
        return imageView;
    } else {
        return [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
}


//-(UIImageView *) profilePic:(bool)shopping color:(UIColor *)color rect:(CGRect) rect{
//    int header_size = 60;
//    if (FBSession.activeSession.isOpen) {
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
////        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [imageView setContentMode:UIViewContentModeCenter];
//        if(shopping){
//            __weak typeof(imageView) weakImage = imageView;
//            [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",facebookId]]
//                               placeholderImage:[UIImage imageNamed:@"avatar_logged_black.png"]
//                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                          if (image && cacheType == SDImageCacheTypeNone)
//                                          {
//                                              weakImage.alpha = 0.0;
//                                              [UIView animateWithDuration:1.0
//                                                               animations:^{
//                                                                   weakImage.alpha = 1.0;
//                                                               }];
//                                          }
//                                      }];
//        } else {
//            __weak typeof(imageView) weakImage = imageView;
//            [imageView          setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal",facebookId]]
//                               placeholderImage:[UIImage imageNamed:@"avatar_logged_white.png"]
//                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                          if (image && cacheType == SDImageCacheTypeNone)
//                                          {
//                                              weakImage.alpha = 0.0;
//                                              [UIView animateWithDuration:1.0
//                                                               animations:^{
//                                                                   weakImage.alpha = 1.0;
//                                                               }];
//                                          }
//                                      }];
//        }
//        
//        imageView.layer.masksToBounds = YES;
////        imageView.layer.cornerRadius = [[NSNumber numberWithInt:header_size] floatValue] / 2.0;
//        if(shopping){
//            CGRect frame = imageView.frame;
//            frame.origin.x = 220;
//            imageView.frame = frame;
//            imageView.layer.borderColor = color.CGColor;
//        } else {
//            CGRect frame = imageView.frame;
//            frame.origin.x = -1;
//            imageView.frame = frame;
//            imageView.layer.borderColor = color.CGColor;
//        }
//        imageView.layer.borderWidth = 1.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        return imageView;
//    } else {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
////        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [imageView setContentMode:UIViewContentModeCenter];
//        if(shopping){
//            CGRect frame = imageView.frame;
//            frame.origin.x = 220;
//            imageView.frame = frame;
//            imageView.image = [UIImage imageNamed:@"avatar_logged_black.png"];
//        } else {
//            CGRect frame = imageView.frame;
//            frame.origin.x = -1;
//            imageView.frame = frame;
//            imageView.image = [UIImage imageNamed:@"avatar_logged_white.png"];
//        }
//        imageView.layer.masksToBounds = YES;
////        imageView.layer.cornerRadius = [[NSNumber numberWithInt:header_size] floatValue] / 2.0;
//        if(shopping){
//            imageView.layer.borderColor = color.CGColor;
//        } else {
//            imageView.layer.borderColor = color.CGColor;
//        }
//        imageView.layer.borderWidth = 1.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        return imageView;
//    }
//}

-(void) signIn:(NSString *)email password: (NSString *) password block:(void (^)(bool, NSString *))block {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"foodcloud_token"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *tokenDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"email",@"password"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000"]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:tokenDescriptor];
    
    User *re = [[User alloc] init];
    re.email = email;
    re.password = password;
    
    [manager postObject:re path:@"/api/v1/tokens" parameters:nil success:
     ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         User *user = [result firstObject];
         NSLog(@"ID: %@", user.foodcloud_token);
         [self completeLogin:user];
         block(logged_in, @"Logged in!");
     } failure:
     ^( RKObjectRequestOperation *operation , NSError *error ){
         NSLog(@"%@",error);
         block(NO,error.description);
     }
     ];
    
}

-(void) signUp:(NSString *)email password: (NSString *) password block:(void (^)(bool, NSString *))block {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"foodcloud_token"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *tokenDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"email",@"password"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000"]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:tokenDescriptor];
    
    User *re = [[User alloc] init];
    re.email = email;
    re.password = password;
    
    [manager postObject:re path:@"/api/v1/registration" parameters:nil success:
     ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         User *user = [result firstObject];
         NSLog(@"ID: %@", user.foodcloud_token);
         [self completeLogin:user];
         block(logged_in, @"Good!");
     } failure:
     ^( RKObjectRequestOperation *operation , NSError *error ){
         NSLog(@"%@",error);
         block(logged_in, error.description);
     }
     ];

}

-(void) logout {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [self writeData:dic];
    logged_in = NO;
}

-(void) completeLogin:(User *) user {
    if([user.foodcloud_token length] > 0){
        logged_in = YES;
        foodcloudToken = user.foodcloud_token;
        NSMutableDictionary *dic = (NSMutableDictionary *)[self readData];
        [dic setObject:foodcloudToken forKey:@"foodcloud_token"];
        [self writeData:dic];
    }
}

-(void) loginWithFacebook:(void (^)(bool, NSString *))block {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"facebook_name",@"facebook_id",@"foodcloud_token"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *tokenDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"facebook_token",@"facebook_id"]];

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000"]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:tokenDescriptor];
    
    User *re = [[User alloc] init];
    re.facebook_token = facebookToken;

    [manager postObject:re path:@"/api/v1/tokens/create_from_facebook" parameters:nil success:
     ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         User *user = [result firstObject];
         [self completeLogin:user];
         block(YES,@"Good!");
         NSLog(@"ID: %@", user.foodcloud_token);
     } failure: ^( RKObjectRequestOperation *operation , NSError *error ){
         NSLog(@"%@",error);
         block(NO,error.description);
     }];

}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
                      block:(void (^)(bool, NSString *))block
{
    switch (state) {
        case FBSessionStateOpen: {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Success"
//                                      message:@"Logged in!"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            
            facebookToken = [session accessTokenData].accessToken;
            
            [self writeData:[[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%@",[session accessTokenData].accessToken],@"facebook_token",
                             [session permissions],@"facebook_permissions",
                             [NSString stringWithFormat:@"%u",[session accessTokenData].loginType],@"facebook_login_type",
             
             nil]];
            
            [self updateFacebookCred];
            [self loginWithFacebook:block];
            
        }
            break;
        case FBSessionStateClosed: {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Closed"
//                                      message:@"Login closed"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            break;
        }
        case FBSessionStateClosedLoginFailed: {
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Error"
//                                      message:@"Login failed"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            break;
        }
        default: {
            break;
        }
    }
    
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
    }
}

- (void)openSession:(void (^)(bool, NSString *))block
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
//         NSLog(@"result.... %@",error);
         [self sessionStateChanged:session state:state error:error block:block];
     }];
}

@end

