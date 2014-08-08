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
        review_popup.review_label.text = @"Please let us know what you don't like about this dish. It won't be publically displayed and we will pass it anonymously along to the restaurant owner to help improve their food!";
    } else {
        review_popup.review_label.text = @"Please let us know what you loved about this dish. In the future it may be displayed directly on the menu!";
    }
    
    [popup show];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) hidePopup {
    [popup hide];
}

-(void) actuallySubmitRating {
    UserSession *session = [UserSession sharedManager];
    self.review = review_popup.review_text.text;
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/dish/set_rating", dishGoUrl]
                                       params:[self cleanDict]
                                   completion:^(id json, JSONModelError *err) {
                                       [session completeLogin];
                                       SetRating *rate = session.current_restaurant_ratings;
                                       NSMutableArray<SetRating> *copy = [NSMutableArray arrayWithArray:rate.current_ratings];
                                       [copy addObject:self];
                                       rate.current_ratings = [NSArray arrayWithArray:copy];
                                   }];
    [self hidePopup];
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
