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

@implementation SetRating
    -(void) setRating {
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@/app/api/v1/dish/set_rating", dishGoUrl]
                                           params:[self cleanDict]
                                       completion:^(id json, JSONModelError *err) {
                                           UserSession *session = [UserSession sharedManager];
                                           SetRating *rate = session.current_restaurant_ratings;
                                           NSMutableArray<SetRating> *copy = [NSMutableArray arrayWithArray:rate.current_ratings];
                                           [copy addObject:self];
                                           rate.current_ratings = [NSArray arrayWithArray:copy];
                                       }];
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
