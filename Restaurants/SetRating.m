//
//  SetRating.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-27.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "SetRating.h"
#import <JSONHTTPClient.h>
#import "Constant.h"
#import "UserSession.h"
#import "AFPopupView.h"
#import "ReviewPopup.h"

@implementation SetRating

AFPopupView *popup;
ReviewPopup *review_popup;

-(void) setRating {
    review_popup = [[ReviewPopup alloc] init];
    [review_popup setup];
    popup = [AFPopupView popupWithView:review_popup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePopup) name:@"HideAFPopup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actuallySubmitRating) name:@"submitReview" object:nil];

    if([self.rating intValue] <= 3){
        review_popup.review_label.text = NSLocalizedString(@"What didn't you like about this dish? We will anonymously let the restaurant know so they can improve their food!",nil);
    } else {
        review_popup.review_label.text = NSLocalizedString(@"Please let us know what you loved about this dish. In the future it may be displayed directly on the menu!",nil);
    }
    
    [popup show];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) hidePopup {
    [popup hide];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) actuallySubmitRating {
    NSLog(@"Submitting Review");
    UserSession *session = [UserSession sharedManager];
    self.review = review_popup.review_text.text;
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/dish/set_rating", dishGoUrl]
                                       params:[self cleanDict]
                                   completion:^(id json, JSONModelError *err) {
                                       if(err){
                                           [self launchDialog:NSLocalizedString(@"We are having difficulty connecting to the internet.",nil)];
                                           return;
                                       }
                                       [session completeLogin];
                                       SetRating *rate = session.current_restaurant_ratings;
                                       NSMutableArray<SetRating> *copy = [NSMutableArray arrayWithArray:rate.current_ratings];
                                       [copy addObject:self];
                                       rate.current_ratings = [NSArray arrayWithArray:copy];
                                   }];
    [self hidePopup];    
}

- (void)launchDialog:(NSString *)msg
{
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    UIView *msg_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,260,100)];
    // Add some custom content to the alert view
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 100)];
    message.text = msg;
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [msg_view addSubview:message];
    [alertView setContainerView:msg_view];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

-(NSDictionary *) cleanDict {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self toDictionary]];
    [dict removeObjectForKey:@"current_ratings"];
    return dict;
    
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSNumber *) current_rating: (NSString *) dish_id {
    for(SetRating *s in self.current_ratings){
        if([s.dish_id isEqualToString:dish_id]){
            return [NSNumber numberWithInt:[s.rating intValue]];
        }
    }
    return [NSNumber numberWithInt:-1];
}
@end
