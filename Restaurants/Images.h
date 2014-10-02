//
//  Images.h
//  DishGo
//
//  Created by Philip Tolton on 2014-09-08.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "JSONModel.h"
#import "Dishes.h"

@class Restaurant;

@protocol Images

@end

@interface Images : JSONModel
    @property (strong, nonatomic) NSString *id;
    @property (strong, nonatomic) NSString *url;
    @property (strong, nonatomic) Restaurant *restaurant;
    @property (strong, nonatomic) Dishes *dish;
@end
