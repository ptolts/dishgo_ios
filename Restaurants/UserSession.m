//
//  UserSession.m
//  Restaurants
//
//  Created by Philip Tolton on 11/26/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "Constant.h"
#import "UserSession.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK/FBAccessTokenData.h>
#import <RestKit/RestKit.h>
#import "SetRating.h"
#import "Lockbox.h"
#import "User.h"
#import "ALAlertBanner.h"
#import "RAppDelegate.h"
#import <JSONHTTPClient.h>
#import "RootViewController.h"

static NSString* kFilename = @"TokenInfo.plist";

@implementation UserSession
@synthesize logged_in;
@synthesize facebookId;
@synthesize facebookUserName;
@synthesize facebookToken;
@synthesize foodcloudToken;
@synthesize main_user;
@synthesize current_restaurant_ratings;
BOOL customUrlSchemeLogin = NO;

void (^ block_pointer)(bool, NSString *);

- (void)clearToken
{
    //Set Cache
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //Clear All Cookies
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSArray *keys = [NSArray arrayWithObjects:@"dishgo_token",@"facebook_token",@"foodcloud_token",@"facebook_login_type",@"facebook_permissions",@"owns_restaurant_id",@"is_admin",nil];
    for(NSString *key in keys){
        [Lockbox setString:@"" forKey:key];
    }
    if ([FBSession activeSession]){
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    FBSession *session = [[FBSession alloc] init];
    [FBSession setActiveSession:session];
    main_user = [[User alloc] init];
}

- (void) writeData:(NSDictionary *) data {
    for(id key in data){
        if([[data objectForKey:key] isKindOfClass:[NSArray class]]){
            [Lockbox setArray:[data objectForKey:key] forKey:key];
        } else {
            NSString *set = [data objectForKey:key];
            NSLog(@"SET: %@ KEY: %@",set,key);
            [Lockbox setString:set forKey:key];
        }
    }
}

- (NSMutableDictionary *) readData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    // These keys are strings
    NSArray *keys = [NSArray arrayWithObjects:@"dishgo_token",@"facebook_token",@"foodcloud_token",@"facebook_login_type",@"facebook_permissions",@"owns_restaurant_id",@"is_admin",nil];
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

+ (id)sharedManager {
    static UserSession *user_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user_session = [[self alloc] init];
    });
    return user_session;
}

- (void)loadUserFromToken:(NSString *)dishgo_token {
    main_user.dishgo_token = dishgo_token;
    customUrlSchemeLogin = YES;
    [self completeLogin];
}

- (id)init {
    if (self = [super init]) {
        main_user = [[User alloc] init];
        logged_in = NO;
        if([[[self readData] objectForKey:@"facebook_token"] length] > 0){
            if ([FBSession activeSession]){
                [[FBSession activeSession] closeAndClearTokenInformation];
            }
            FBSession *session = [[FBSession alloc] init];
            [FBSession setActiveSession:session];
            
            if(session.state == FBSessionStateCreated){
                NSDictionary *dic = [self readData];
                NSString *tok = [dic objectForKey:@"facebook_token"];
                NSArray *per = [dic objectForKey:@"facebook_permissions"];
                FBSessionLoginType lt = (FBSessionLoginType) [dic objectForKey:@"facebook_login_type"];
                FBAccessTokenData *access_token = [FBAccessTokenData createTokenFromString:tok permissions:per expirationDate:nil loginType:lt refreshDate:nil];
                [session openFromAccessTokenData:access_token completionHandler:
                 ^(FBSession *session, FBSessionState state, NSError *error) {
                     [self sessionStateChanged:session state:state error:error block:^(bool obj, NSString *result) {

                         
                     }];
                 }];
            }
        }
        NSString *saved_token = [[self readData] objectForKey:@"dishgo_token"];
        if ([saved_token length] > 0){
            foodcloudToken = saved_token;
            main_user.dishgo_token = foodcloudToken;
            [self completeLogin];
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

-(void) fetch_ratings:(NSString *)restaurant_id {
    current_restaurant_ratings = [[SetRating alloc] init];
    current_restaurant_ratings.dishgo_token = main_user.dishgo_token;
    current_restaurant_ratings.restaurant_id = restaurant_id;
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/dish/get_ratings", dishGoUrl]
                                       params:[current_restaurant_ratings cleanDict]
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       current_restaurant_ratings = [[SetRating alloc] initWithDictionary:json error:nil];
                                   }];
}


-(void) signIn:(NSString *)email password: (NSString *) password block:(void (^)(bool, NSString *))block {
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v2/tokens", dishGoUrl]
                                       params:@{@"email":email,@"password":password}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       
                                       if(err.description){
                                           block(NO, NSLocalizedString([json objectForKey:@"error"],nil));
                                           return;
                                       }
                                       
                                       main_user = [[User alloc] initWithDictionary:json error:nil];
                                       logged_in = YES;
                                       [self completeLogin];
                                       block(logged_in,@"Logged in!");
                                       NSLog(@"ID: %@", main_user.dishgo_token);
                                   }];

    
}

-(void) setAddress:(NSMutableDictionary *) dict block:(void (^)(bool, NSString *))block; {
    
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
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/registration",dishGoUrl]
                                       params:@{@"email":email,@"password":password}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       main_user = [[User alloc] initWithDictionary:json error:nil];
                                       if(err.description){
                                           block(NO, [json objectForKey:@"error"]);
                                       } else {
                                           block(YES, @"Success!");
                                       }
                                   }];
    
}

-(void) logout {
    [self clearToken];
    logged_in = NO;
}

-(void) completeLogin {
    int old_token_count = [main_user.dishcoins intValue];
    if([main_user.dishgo_token length] > 0){
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v2/tokens/load_user",dishGoUrl]
                                           params:@{@"dishgo_token":main_user.dishgo_token}
                                       completion:^(NSDictionary *json, JSONModelError *err) {
                                           
                                           main_user = [[User alloc] initWithDictionary:json error:nil];
                                           
                                           if(old_token_count != 0 && [main_user.dishcoins intValue] > old_token_count){
                                               [self alertDishCoin:([main_user.dishcoins intValue] - old_token_count)];
                                           }
                                           
                                           [self writeData:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                            main_user.dishgo_token,@"dishgo_token", nil]];
                                           
                                           if(customUrlSchemeLogin){
                                               [self launchDialog:NSLocalizedString(@"Congratulations!\nYour account has been created and you are logged in.",nil)];
                                               customUrlSchemeLogin = NO;
                                           }
                                                            
                                           logged_in = YES;
                                       }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in_before"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)launchDialog:(NSString *)msg
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    message.text = msg;
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [alertView setContainerView:message];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

-(void) alertDishCoin: (int) difference {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;
    NSString *msg = [NSString stringWithFormat:@"Earned %d additional DishCoins",difference];
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:rootView
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionBottom
                                                        title:@"Success!"
                                                     subtitle:msg];
    [banner show];
}


-(void) loginWithFacebook:(void (^)(bool, NSString *))block {
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v2/tokens/create_from_facebook",dishGoUrl]
                                       params:@{@"facebook_token":facebookToken,@"facebook_id":@""}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       main_user = [[User alloc] initWithDictionary:json error:nil];
                                       logged_in = YES;
                                       [self completeLogin];
                                       block(YES,@"Good!");
                                       NSLog(@"ID: %@", main_user.dishgo_token);
                                   }];
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
                      block:(void (^)(bool, NSString *))block
{
    NSLog(@"Session state: %u",state);
    switch (state) {
        case FBSessionStateOpen: {
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
            [self clearToken];
            logged_in = NO;
            main_user = [[User alloc] init];
            break;
        }
        case FBSessionStateClosedLoginFailed: {
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        }
        default: {
            break;
        }
    }
    
}

- (void)openSession:(void (^)(bool, NSString *))block
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(cancelHud)
                                                name:@"attemptingFacebookLogin"
                                              object:nil];
    
    block_pointer = block;
    
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         NSLog(@"result.... %@",error);
         [self sessionStateChanged:session state:state error:error block:block];
     }];    
}

- (void) cancelHud {
    NSLog(@"Canceling Facebook Login!");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attemptingFacebookLogin" object:nil];
//    block_pointer(NO,@"Please try again");
}

@end

