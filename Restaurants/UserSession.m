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
#import "Lockbox.h"
#import "User.h"

static NSString* kFilename = @"TokenInfo.plist";

@implementation UserSession
@synthesize logged_in;
@synthesize facebookId;
@synthesize facebookUserName;
@synthesize facebookToken;
@synthesize foodcloudToken;
@synthesize main_user;

//- (void)cacheFBAccessTokenData:(FBAccessTokenData *)accessToken {
//    NSDictionary *tokenInformation = [accessToken dictionary];
//    [self writeData:tokenInformation];
//}

//- (FBAccessTokenData *)fetchFBAccessTokenData
//{
//    NSDictionary *tokenInformation = [self readData];
//    if (nil == tokenInformation) {
//        return nil;
//    } else {
//        return [FBAccessTokenData createTokenFromDictionary:tokenInformation];
//    }
//}

//- (void)clearToken
//{
//    [self writeData:[NSDictionary dictionaryWithObjectsAndKeys:nil]];
//}
//
//- (NSString *) filePath {
//    NSArray *paths =
//    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                        NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths lastObject];
//    return [documentsDirectory stringByAppendingPathComponent:kFilename];
//}
//
//- (void) writeData:(NSDictionary *) data {
//    NSLog(@"File = %@ and Data = %@", self.tokenFilePath, data);
//    BOOL success = [data writeToFile:self.tokenFilePath atomically:YES];
//    if (!success) {
//        NSLog(@"Error writing to file");
//    }
//}
//
//- (NSMutableDictionary *) readData {
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.tokenFilePath];
//    NSLog(@"File = %@ and data = %@", self.tokenFilePath, data);
//    return data;
//}

- (void)clearToken
{
    NSArray *keys = [NSArray arrayWithObjects:@"facebook_token",@"foodcloud_token",@"facebook_login_type",@"facebook_permissions", nil];
    for(NSString *key in keys){
        [Lockbox setString:@"" forKey:key];
    }
}

- (void) writeData:(NSDictionary *) data {
    for(id key in data){
        if([[data objectForKey:key] isKindOfClass:[NSArray class]]){
            [Lockbox setArray:[data objectForKey:key] forKey:key];
        } else {
            NSString *set = [data objectForKey:key];
            NSLog(@"SET: %@",set);
            [Lockbox setString:set forKey:key];
        }
    }
}

- (NSMutableDictionary *) readData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    // These keys are strings
    NSArray *keys = [NSArray arrayWithObjects:@"facebook_token",@"foodcloud_token",@"facebook_login_type",@"facebook_permissions", nil];
    for(NSString *key in keys){
        NSLog(@"Key: %@",key);
        NSString *get = [Lockbox stringForKey:key];
        if(get == nil){
            [data setObject:@"" forKey:key];
        } else {
            [data setObject:get forKey:key];
        }
    }
    
    // These keys are arrays
    keys = [NSArray arrayWithObjects:@"facebook_permissions", nil];
    for(NSString *key in keys){
        NSLog(@"Key for Array: %@",key);
        NSArray *get = [Lockbox arrayForKey:key];
        if(get == nil){
            [data setObject:[[NSArray alloc] init] forKey:key];
        } else {
            [data setObject:get forKey:key];
        }
    }
    return data;
}

///// Store a secret
//[[GSKeychain systemKeychain] setSecret:@"t0ps3kr1t" forKey:@"myAccessToken"];
//
//// Fetch a secret
//NSString *secret = [[GSKeychain systemKeychain] secretForKey:@"myAccessToken"];
//
//// Delete a secret
//[[GSKeychain systemKeychain] removeSecretForKey:@"myAccessToken"];
//
//// Delete all secrets
//[[GSKeychain systemKeychain] removeAllSecrets];

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
        main_user = [[User alloc] init];
        logged_in = NO;
//        self.tokenFilePath = [self filePath];
        if([[[self readData] objectForKey:@"facebook_token"] length] > 0){
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
        } else if ([[[self readData] objectForKey:@"foodcloud_token"] length] > 0){
            NSDictionary *dic = [self readData];
            NSString *tok = [dic objectForKey:@"foodcloud_token"];
            foodcloudToken = tok;
            main_user.foodcloud_token = foodcloudToken;
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
             main_user.facebook_name = facebookUserName;
             main_user.facebook_id = facebookId;
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
                           placeholderImage:[UIImage imageNamed:@"avatar_logged_white.png"]
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
    [responseMapping addAttributeMappingsFromArray:@[@"foodcloud_token",@"phone_number",@"street_number",@"street_address",@"city",@"postal_code",@"province",@"apartment_number"]];
    
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
         main_user = [result firstObject];
         NSLog(@"ID: %@", main_user.foodcloud_token);
         [self completeLogin:main_user];
         block(logged_in, @"Logged in!");
     } failure:
     ^( RKObjectRequestOperation *operation , NSError *error ){
         NSLog(@"%@",error);
         block(NO,error.description);
     }
     ];
    
}

-(void) setAddress:(NSMutableDictionary *) dict block:(void (^)(bool, NSString *))block; {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
    [responseMapping addAttributeMappingsFromArray:@[@"phone_number",@"street_number",@"street_address",@"city",@"postal_code",@"province",@"apartment_number"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *tokenDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"phone_number",@"street_number",@"street_address",@"city",@"postal_code",@"province",@"apartment_number",@"foodcloud_token"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://dev.foodcloud.ca:3000"]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:tokenDescriptor];
    
    main_user.phone_number = dict[@"phone_number"];
    main_user.street_number = dict[@"street_number"];
    main_user.street_address = dict[@"street_address"];
    main_user.city = dict[@"city"];
    main_user.postal_code = dict[@"postal_code"];
    main_user.province = dict[@"province"];
    main_user.apartment_number = dict[@"apartment_number"];
    main_user.foodcloud_token = foodcloudToken;
    
    [manager postObject:main_user path:@"/api/v1/user/add_address" parameters:nil success:
     ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         NSLog(@"SAVED ADDRESS!");
         block(YES, @"Good!");
     } failure:
     ^( RKObjectRequestOperation *operation , NSError *error ){
         NSLog(@"%@",error);
         block(NO, error.description);
     }
     ];
    
}

-(BOOL) hasAddress{
    if([main_user.street_address length] > 0){
        return YES;
    }
    return NO;
}

-(User *) fetchUser {
    return main_user;
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
    [responseMapping addAttributeMappingsFromArray:@[@"facebook_name",@"facebook_id",@"foodcloud_token",@"phone_number",@"street_number",@"street_address",@"city",@"postal_code",@"province",@"apartment_number"]];
    
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
         main_user = [result firstObject];
         NSLog(@"ADDRESS: %@",main_user.street_address);
         [self completeLogin:main_user];
         block(YES,@"Good!");
         NSLog(@"ID: %@", main_user.foodcloud_token);
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
            main_user.facebook_token = facebookToken;
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

