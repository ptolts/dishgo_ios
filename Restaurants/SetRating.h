//
//  SetRating.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-27.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@protocol SetRating

@end

@interface SetRating : JSONModel
    @property (nonatomic, copy) NSString *dishgo_token;
    @property (nonatomic, copy) NSString *dish_id;
    @property (nonatomic, copy) NSString *restaurant_id;
    @property (nonatomic, copy) NSString *rating;
    @property (nonatomic, copy) NSArray<SetRating> *current_ratings;
    - (void) setRating;
    - (NSDictionary *) cleanDict;
    -(NSNumber *) current_rating: (NSString *) dish_id;
@end
